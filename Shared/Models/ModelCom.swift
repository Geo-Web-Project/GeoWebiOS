//
//  ModelCom.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import Foundation
import RealityKit
import VarInt
import CID
import Multicodec
import SwiftData
import SwiftMUD
import Web3
import Web3ContractABI
import CryptoSwift

enum ModelEncodingFormat: UInt8, Codable {
    case Glb
    case Usdz
}

@Model
final class ModelCom: Component, Record {
    var table: Table?
    
    @Attribute(.unique) var uniqueKey: String
    var lastUpdatedAtBlock: UInt

    var key: Data
    
    var contentURI: String?
    var encodingFormat: ModelEncodingFormat?
    
    @Transient
    lazy var contentUrl: URL? = {
        guard contentURI != nil, let contentURI = URL(string: contentURI!) else {
            return nil
        }
        
        switch contentURI.scheme {
        case "ipfs":
            do {
                let cid = try CID(contentURI.host()!)
                let ext = switch encodingFormat {
                case .Glb:
                    ".glb"
                case .Usdz:
                    ".usdz"
                default:
                    ""
                }
                return URL(string: "https://w3s.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
            } catch {
                return nil
            }
        default:
            return contentURI
        }
    }()
    
    init(uniqueKey: String, lastUpdatedAtBlock: UInt, key: Data, contentURI: String, encodingFormat: ModelEncodingFormat) {
        self.uniqueKey = uniqueKey
        self.lastUpdatedAtBlock = lastUpdatedAtBlock

        self.key = key
        self.contentURI = contentURI
        self.encodingFormat = encodingFormat
    }
    
    static func setRecord(storeActor: StoreActor, table: Table, values: [String : Any], blockNumber: EthereumQuantity) async throws {
        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        
        guard let staticData = values["staticData"] as? Data else { throw SetRecordError.invalidData }
        guard let encodingFormat = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint8, data: staticData.makeBytes()) as? UInt8 else { throw SetRecordError.invalidNativeValue }
        guard let modelEncodingFormat = ModelEncodingFormat(rawValue: encodingFormat) else { throw SetRecordError.invalidData }
        
        guard let encodedLengthsData = values["encodedLengths"] as? Data else { throw SetRecordError.invalidData }
        guard let encodedLengthsBytes = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: encodedLengthsData.makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        let (_, encodedLengths) = try ProtocolParser.hexToPackedCounter(data: encodedLengthsBytes.makeBytes())
        
        guard let dynamicData = values["dynamicData"] as? Data else { throw SetRecordError.invalidData }
        
        let dataBytes = dynamicData.makeBytes()
        let bytesOffset = 0
        let contentURIData = Array(dataBytes[bytesOffset..<Int(encodedLengths[0])])
        
        guard let contentURI = try ProtocolParser.decodeDynamicField(abiType: SolidityType.string, data: contentURIData) as? String else { throw SetRecordError.invalidNativeValue }

        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
        
        try await storeActor.upsertModelCom(uniqueKey: uniqueKey, tableIdentifier: table.id, lastUpdatedAtBlock: UInt(blockNumber.quantity), key: key, contentURI: contentURI, encodingFormat: modelEncodingFormat)
    }
    
    static func spliceStaticData(storeActor: StoreActor, table: Table, values: [String : Any], blockNumber: EthereumQuantity) async throws {
        
    }
    
    static func spliceDynamicData(storeActor: StoreActor, table: Table, values: [String : Any], blockNumber: EthereumQuantity) async throws {
        
    }
    
    static func deleteRecord(storeActor: StoreActor, table: Table, values: [String : Any], blockNumber: EthereumQuantity) async throws {
        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }

        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
        
        try await storeActor.deleteModelCom(uniqueKey: uniqueKey, lastUpdatedAtBlock: UInt(blockNumber.quantity))
    }
}

extension StoreActor {
    func fetchModelComs() throws -> [ModelCom] {
        return try modelContext.fetch(FetchDescriptor<ModelCom>())
    }
    
    func upsertModelCom(uniqueKey: String, tableIdentifier: PersistentIdentifier, lastUpdatedAtBlock: UInt, key: Data, contentURI: String, encodingFormat: ModelEncodingFormat) throws {
        guard let table = self[tableIdentifier, as: Table.self] else { return }
        
        let latestValue = FetchDescriptor<ModelCom>(
            predicate: #Predicate { $0.uniqueKey == uniqueKey }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.first?.lastUpdatedAtBlock
        
        if let existingRecord = results.first {
            existingRecord.encodingFormat = encodingFormat
            existingRecord.contentURI = contentURI
            existingRecord.lastUpdatedAtBlock = lastUpdatedAtBlock
        } else if latestBlockNumber == nil || latestBlockNumber! < lastUpdatedAtBlock {
            let record = ModelCom(
                uniqueKey: uniqueKey,
                lastUpdatedAtBlock: lastUpdatedAtBlock,
                key: key,
                contentURI: contentURI,
                encodingFormat: encodingFormat
            )
            record.table = table
            modelContext.insert(record)
            
            try modelContext.save()
        }
    }
    
    func deleteModelCom(uniqueKey: String, lastUpdatedAtBlock: UInt) throws {
        let latestValue = FetchDescriptor<ModelCom>(
            predicate: #Predicate { $0.uniqueKey == uniqueKey }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.first?.lastUpdatedAtBlock
        
        if let existingRecord = results.first, (latestBlockNumber == nil || latestBlockNumber! < lastUpdatedAtBlock) {
            modelContext.delete(existingRecord)
            
            try modelContext.save()
        }
    }
}

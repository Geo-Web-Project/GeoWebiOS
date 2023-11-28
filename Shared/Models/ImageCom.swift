//
//  ImageCom.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import Foundation
import RealityKit
import CID
import Multicodec
import SwiftData
import SwiftMUD
import Web3
import Web3ContractABI
import CryptoSwift

enum ImageEncodingFormat: UInt8, Codable {
    case Jpeg
    case Png
    case Svg
}

@Model
final class ImageCom: Component, Record {
    var table: Table?
    
    @Attribute(.unique) var uniqueKey: String
    var lastUpdatedAtBlock: UInt

    var key: Data
    
    var encodingFormat: ImageEncodingFormat?
    var physicalWidthInMillimeters: UInt64?
    var contentURI: String?
    
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
                case .Png:
                    ".png"
                case .Jpeg:
                    ".jpeg"
                case .Svg:
                    ".svg"
                default:
                    ""
                }
                return URL(string: "https://dweb.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
            } catch {
                return nil
            }
        default:
            return contentURI
        }
    }()
    
    init(uniqueKey: String, lastUpdatedAtBlock: UInt, key: Data, encodingFormat: ImageEncodingFormat, physicalWidthInMillimeters: UInt64, contentURI: String) {
        self.uniqueKey = uniqueKey
        self.lastUpdatedAtBlock = lastUpdatedAtBlock

        self.key = key
        self.encodingFormat = encodingFormat
        self.physicalWidthInMillimeters = physicalWidthInMillimeters
        self.contentURI = contentURI
    }
    
    static func setRecord(storeActor: StoreActor, table: Table, values: [String : Any], blockNumber: EthereumQuantity) async throws {
        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        
        guard let staticData = values["staticData"] as? Data else { throw SetRecordError.invalidData }
        let staticDataBytes = staticData.makeBytes()
        let staticDataLengths: [Int] = [
            Int(SolidityType.uint8.decodeLength!),
            Int(SolidityType.uint64.decodeLength!)
        ]
        
        var bytesOffset = 0
        let encodingFormatData = Array(staticDataBytes[bytesOffset..<staticDataLengths[0]])
        bytesOffset += encodingFormatData.count
        let physicalWidthData = Array(staticDataBytes[bytesOffset...])
        bytesOffset += physicalWidthData.count
        
        guard let encodingFormat = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint8, data: encodingFormatData) as? UInt8 else { throw SetRecordError.invalidNativeValue }
        guard let physicalWidthInMillimeters = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint64, data: physicalWidthData) as? UInt64 else { throw SetRecordError.invalidNativeValue }
        guard let imageEncodingFormat = ImageEncodingFormat(rawValue: encodingFormat) else { throw SetRecordError.invalidData }
        
        guard let encodedLengthsData = values["encodedLengths"] as? Data else { throw SetRecordError.invalidData }
        guard let encodedLengthsBytes = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: encodedLengthsData.makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        let (_, encodedLengths) = try ProtocolParser.hexToPackedCounter(data: encodedLengthsBytes.makeBytes())
        
        guard let dynamicData = values["dynamicData"] as? Data else { throw SetRecordError.invalidData }
        
        let dataBytes = dynamicData.makeBytes()
        bytesOffset = 0
        let contentURIData = Array(dataBytes[bytesOffset..<Int(encodedLengths[0])])
        
        guard let contentURI = try ProtocolParser.decodeDynamicField(abiType: SolidityType.string, data: contentURIData) as? String else { throw SetRecordError.invalidNativeValue }

        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
        
        try await storeActor.upsertImageCom(uniqueKey: uniqueKey, tableId: table.id, lastBlock: UInt(blockNumber.quantity), key: key, format: imageEncodingFormat, physicalWidth: physicalWidthInMillimeters, contentURI: contentURI)
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
        
        try await storeActor.deleteImageCom(uniqueKey: uniqueKey, lastUpdatedAtBlock: UInt(blockNumber.quantity))
    }
}

extension StoreActor {
    func fetchImageComs() throws -> [ImageCom] {
        try modelContext.fetch(FetchDescriptor<ImageCom>())
    }
    
    func upsertImageCom(uniqueKey: String, tableId: PersistentIdentifier, lastBlock: UInt, key: Data, format: ImageEncodingFormat, physicalWidth: UInt64, contentURI: String) throws {
        guard let table = self[tableId, as: Table.self] else { return }
        
        let latestValue = FetchDescriptor<ImageCom>(
            predicate: #Predicate { $0.uniqueKey == uniqueKey }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.first?.lastUpdatedAtBlock
        
        if let existingRecord = results.first {
            existingRecord.encodingFormat = format
            existingRecord.physicalWidthInMillimeters = physicalWidth
            existingRecord.contentURI = contentURI
            existingRecord.lastUpdatedAtBlock = lastBlock
        } else if latestBlockNumber == nil || latestBlockNumber! < lastBlock {
            let record = ImageCom(
                uniqueKey: uniqueKey,
                lastUpdatedAtBlock: lastBlock,
                key: key,
                encodingFormat: format,
                physicalWidthInMillimeters: physicalWidth,
                contentURI: contentURI
            )
            record.table = table
            modelContext.insert(record)
            
            try modelContext.save()
        }
    }
    
    func deleteImageCom(uniqueKey: String, lastUpdatedAtBlock: UInt) throws {
        let latestValue = FetchDescriptor<ImageCom>(
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

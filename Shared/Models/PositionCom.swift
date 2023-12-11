//
//  PositionCom.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-28.
//

import Foundation
import RealityKit
import SwiftData
import SwiftMUD
import Web3
import Web3ContractABI
import CryptoSwift
import ARKit

@Model
final class PositionCom: Component, Record {
    var table: Table?
    
    @Attribute(.unique) var uniqueKey: String
    var lastUpdatedAtBlock: UInt

    var key: Data
    
    var h: Int32?
    var geohash: String?
    
    @Transient
    var geoAnchor: ARGeoAnchor?
    
    init(uniqueKey: String, lastUpdatedAtBlock: UInt, key: Data, h: Int32, geohash: String) {
        self.uniqueKey = uniqueKey
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
        self.key = key
        
        self.h = h
        self.geohash = geohash
    }
    
    static func setRecord(storeActor: StoreActor, table: Table, values: [String : Any], blockNumber: EthereumQuantity) async throws {
        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        
        guard let staticData = values["staticData"] as? Data else { throw SetRecordError.invalidData }
        let staticDataBytes = staticData.makeBytes()        
        let bytesOffset = 0
        let hData = Array(staticDataBytes[bytesOffset...])
        
        guard let h = try ProtocolParser.decodeStaticField(abiType: SolidityType.int32, data: hData) as? Int32 else { throw SetRecordError.invalidNativeValue }
        
        guard let encodedLengthsData = values["encodedLengths"] as? Data else { throw SetRecordError.invalidData }
        guard let encodedLengthsBytes = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: encodedLengthsData.makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        let (_, encodedLengths) = try ProtocolParser.hexToPackedCounter(data: encodedLengthsBytes.makeBytes())
        
        guard let dynamicData = values["dynamicData"] as? Data else { throw SetRecordError.invalidData }
        
        let dataBytes = dynamicData.makeBytes()
        let geohashData = Array(dataBytes[bytesOffset..<Int(encodedLengths[0])])
        
        guard let geohash = try ProtocolParser.decodeDynamicField(abiType: SolidityType.string, data: geohashData) as? String else { throw SetRecordError.invalidNativeValue }

        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
        
        try await storeActor.upsertPositionCom(uniqueKey: uniqueKey, tableIdentifier: table.id, lastUpdatedAtBlock: UInt(blockNumber.quantity), key: key, h: h, geohash: geohash)
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
        
        try await storeActor.deletePositionCom(uniqueKey: uniqueKey, lastUpdatedAtBlock: UInt(blockNumber.quantity))
    }
}

extension StoreActor {
    func fetchPositionComs() throws -> [PositionCom] {
        return try modelContext.fetch(FetchDescriptor<PositionCom>())
    }
    
    func upsertPositionCom(uniqueKey: String, tableIdentifier: PersistentIdentifier, lastUpdatedAtBlock: UInt, key: Data, h: Int32, geohash: String) throws {
        guard let table = self[tableIdentifier, as: Table.self] else { return }
        
        let latestValue = FetchDescriptor<PositionCom>(
            predicate: #Predicate { $0.uniqueKey == uniqueKey }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.first?.lastUpdatedAtBlock
        
        if let existingRecord = results.first {
            existingRecord.h = h
            existingRecord.geohash = geohash
            existingRecord.lastUpdatedAtBlock = lastUpdatedAtBlock
        } else if latestBlockNumber == nil || latestBlockNumber! < lastUpdatedAtBlock {
            let record = PositionCom(
                uniqueKey: uniqueKey,
                lastUpdatedAtBlock: lastUpdatedAtBlock,
                key: key,
                h: h,
                geohash: geohash
            )
            record.table = table
            modelContext.insert(record)
            
            try modelContext.save()
        }
    }
    
    func deletePositionCom(uniqueKey: String, lastUpdatedAtBlock: UInt) throws {
        let latestValue = FetchDescriptor<PositionCom>(
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

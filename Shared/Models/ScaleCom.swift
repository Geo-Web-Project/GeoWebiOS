//
//  ScaleCom.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-14.
//

import Foundation
import RealityKit
import SwiftData
import SwiftMUD
import Web3
import Web3ContractABI
import CryptoSwift

@Model
final class ScaleCom: Component, Record {
    var table: Table?
    
    @Attribute(.unique) var uniqueKey: String
    var lastUpdatedAtBlock: UInt

    var key: Data
    
    var x: Int16?
    var y: Int16?
    var z: Int16?
    
    init(uniqueKey: String, lastUpdatedAtBlock: UInt, key: Data, x: Int16, y: Int16, z: Int16) {
        self.uniqueKey = uniqueKey
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
        self.key = key
        
        self.x = x
        self.y = y
        self.z = z
    }
    
    static func setRecord(storeActor: StoreActor, table: Table, values: [String : Any], blockNumber: EthereumQuantity) async throws {
        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        
        guard let staticData = values["staticData"] as? Data else { throw SetRecordError.invalidData }
        let staticDataBytes = staticData.makeBytes()
        let staticDataLengths: [Int] = [
            Int(SolidityType.int16.decodeLength!),
            Int(SolidityType.int16.decodeLength!),
            Int(SolidityType.int16.decodeLength!)
        ]
        
        var bytesOffset = 0
        let xData = Array(staticDataBytes[bytesOffset..<staticDataLengths[0]])
        bytesOffset += xData.count
        let yData = Array(staticDataBytes[bytesOffset..<(bytesOffset+staticDataLengths[1])])
        bytesOffset += yData.count
        let zData = Array(staticDataBytes[bytesOffset...])
        bytesOffset += zData.count
        
        guard let x = try ProtocolParser.decodeStaticField(abiType: SolidityType.int16, data: xData) as? Int16 else { throw SetRecordError.invalidNativeValue }
        guard let y = try ProtocolParser.decodeStaticField(abiType: SolidityType.int16, data: yData) as? Int16 else { throw SetRecordError.invalidNativeValue }
        guard let z = try ProtocolParser.decodeStaticField(abiType: SolidityType.int16, data: zData) as? Int16 else { throw SetRecordError.invalidNativeValue }

        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
        
        try await storeActor.upsertScaleCom(uniqueKey: uniqueKey, tableIdentifier: table.id, lastUpdatedAtBlock: UInt(blockNumber.quantity), key: key, x: x, y: y, z: z)
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
        
        try await storeActor.deleteScaleCom(uniqueKey: uniqueKey, lastUpdatedAtBlock: UInt(blockNumber.quantity))
    }
}

extension StoreActor {
    func fetchScaleComs() throws -> [ScaleCom] {
        return try modelContext.fetch(FetchDescriptor<ScaleCom>())
    }
    
    func upsertScaleCom(uniqueKey: String, tableIdentifier: PersistentIdentifier, lastUpdatedAtBlock: UInt, key: Data, x: Int16, y: Int16, z: Int16) throws {
        guard let table = self[tableIdentifier, as: Table.self] else { return }
        
        let latestValue = FetchDescriptor<ScaleCom>(
            predicate: #Predicate { $0.uniqueKey == uniqueKey }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.first?.lastUpdatedAtBlock
        
        if let existingRecord = results.first {
            existingRecord.x = x
            existingRecord.y = y
            existingRecord.z = z
            existingRecord.lastUpdatedAtBlock = lastUpdatedAtBlock
        } else if latestBlockNumber == nil || latestBlockNumber! < lastUpdatedAtBlock {
            let record = ScaleCom(
                uniqueKey: uniqueKey,
                lastUpdatedAtBlock: lastUpdatedAtBlock,
                key: key,
                x: x,
                y: y,
                z: z
            )
            record.table = table
            modelContext.insert(record)
            
            try modelContext.save()
        }
    }
    
    func deleteScaleCom(uniqueKey: String, lastUpdatedAtBlock: UInt) throws {
        let latestValue = FetchDescriptor<ScaleCom>(
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

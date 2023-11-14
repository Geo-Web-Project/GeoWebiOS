////
////  NameCom.swift
////  GeoWebiOS
////
////  Created by Cody Hatfield on 2023-07-25.
////
//
//import Foundation
//import SwiftData
//import Web3
//import Web3ContractABI
//import SwiftMUD
//import CryptoSwift
//
//@Model
//final class NameCom: Record {
//    var table: Table?
//    
//    @Attribute(.unique) var uniqueKey: String
//
//    var key: Data
//    var value: String
//    var lastUpdatedAtBlock: UInt
//    
//    init(uniqueKey: String, key: Data, value: String, lastUpdatedAtBlock: UInt) {
//        self.uniqueKey = uniqueKey
//        self.key = key
//        self.value = value
//        self.lastUpdatedAtBlock = lastUpdatedAtBlock
//    }
//    
//    static func setRecord(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
//        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
//        
//        guard let encodedLengthsData = values["encodedLengths"] as? Data else { throw SetRecordError.invalidData }
//        guard let encodedLengthsBytes = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: encodedLengthsData.makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
//        let (_, encodedLengths) = try ProtocolParser.hexToPackedCounter(data: encodedLengthsBytes.makeBytes())
//
//        guard let dynamicData = values["dynamicData"] as? Data else { throw SetRecordError.invalidData }
//        
//        let dataBytes = dynamicData.makeBytes()
//        let bytesOffset = 0
//        let valueData = Array(dataBytes[bytesOffset..<Int(encodedLengths[0])])
//        
//        guard let value = try ProtocolParser.decodeDynamicField(abiType: SolidityType.string, data: valueData) as? String else { throw SetRecordError.invalidNativeValue }
//
//        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
//        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
//        
//        let latestValue = FetchDescriptor<NameCom>(
//            predicate: #Predicate { $0.uniqueKey == uniqueKey }
//        )
//        let results = try modelContext.fetch(latestValue)
//        let latestBlockNumber = results.first?.lastUpdatedAtBlock
//        
//        if let existingRecord = results.first {
//            existingRecord.value = value
//            existingRecord.lastUpdatedAtBlock = UInt(blockNumber.quantity)
//        } else if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
//            let record = NameCom(uniqueKey: uniqueKey, key: key, value: value, lastUpdatedAtBlock: UInt(blockNumber.quantity))
//            record.table = table
//            modelContext.insert(record)
//        }
//    }
//    
//    static func spliceStaticData(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//        
//    }
//    
//    static func spliceDynamicData(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//        
//    }
//    
//    static func deleteRecord(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
//        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
//        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
//
//        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
//        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
//        
//        let latestValue = FetchDescriptor<NameCom>(
//            predicate: #Predicate { $0.uniqueKey == uniqueKey }
//        )
//        let results = try modelContext.fetch(latestValue)
//        let latestBlockNumber = results.first?.lastUpdatedAtBlock
//        
//        if let existingRecord = results.first, (latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity) {
//            modelContext.delete(existingRecord)
//        }
//    }
//}

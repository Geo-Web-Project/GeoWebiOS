//
//  Counter.swift
//  MUDTesting
//
//  Created by Cody Hatfield on 2023-07-25.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI

@Model
final class Name {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "Name")
    
    @Attribute(.unique) var worldAddress: String
    var value: String
    var lastUpdatedAtBlock: UInt
    
    init(worldAddress: EthereumAddress, value: String, lastUpdatedAtBlock: UInt) {
        self.worldAddress = worldAddress.hex(eip55: true)
        self.value = value
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
    }
    
    static func setField(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let nativeValue = try ProtocolParser.decodeDynamicField(abiType: SolidityType.string, data: newValue.makeBytes()) as? String else { throw SetFieldError.invalidNativeValue }
        
        let addressStr = address.hex(eip55: true)
        let latestName = FetchDescriptor<Name>(
            predicate: #Predicate { $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latestName)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(Name(worldAddress: address, value: nativeValue, lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}

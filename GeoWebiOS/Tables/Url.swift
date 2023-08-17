//
//  Url.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-17.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI

@Model
final class Url {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }
    
    static let tableId: TableId = TableId(namespace: "geoweb", name: "Url")
    
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
        guard let nativeValue = String(data: newValue, encoding: .utf8) else { throw SetFieldError.invalidNativeValue }
        
        let addressStr = address.hex(eip55: true)
        let latestName = FetchDescriptor<Url>(
            predicate: #Predicate { $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latestName)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(Url(worldAddress: address, value: nativeValue, lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}


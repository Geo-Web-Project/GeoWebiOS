//
//  AnchorComponent.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-30.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI
import VarInt
import CID
import Multicodec

@Model
final class AnchorComponent {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "AnchorComponent")
    
    @Attribute(.unique) var worldKey: String
    var key: Data
    var worldAddress: String
    var anchor: Data
    var lastUpdatedAtBlock: UInt
    
    init(key: Data, worldAddress: EthereumAddress, anchor: Data, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress.hex(eip55: true)
        self.anchor = anchor
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
        
        self.worldKey = "\(worldAddress.hex(eip55: true))/\(key.toHexString())"
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let keys = values["key"] as? [Data] else { throw SetFieldError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetFieldError.invalidNativeValue }

        
        /*
            anchor: "bytes32"
         */
        let dataBytes = newValue.makeBytes()
        let decodeLengths: [Int] = [
            Int(SolidityType.bytes(length: 32).decodeLength!),
        ]
        
        var bytesOffset = 0
        let anchorData = Array(dataBytes[bytesOffset..<decodeLengths[0]])
        bytesOffset += anchorData.count
        
        guard let anchor = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: anchorData) as? Data else { throw SetFieldError.invalidNativeValue }
                
        let addressStr = address.hex(eip55: true)
        let latest = FetchDescriptor<AnchorComponent>(
            predicate: #Predicate { $0.key == key && $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latest)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(AnchorComponent(key: key, worldAddress: address, anchor: anchor, lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}

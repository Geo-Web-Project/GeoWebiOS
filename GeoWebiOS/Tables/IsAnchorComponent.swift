//
//  IsAnchorComponent.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-30.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI
import RealityKit

@Model
final class IsAnchorComponent: ARComponent {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "IsAnchorComponent")
    
    @Attribute(.unique) var key: Data
    var worldAddress: String
    var value: Bool?
    var lastUpdatedAtBlock: UInt
    
    init(key: Data, worldAddress: EthereumAddress, value: Bool, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress.hex(eip55: true)
        self.value = value
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
    }
    
    func updateARView(_ arView: ARView) {
        let entity = arView.scene.findEntity(named: key.toHexString()) as? AnchorEntity ?? AnchorEntity()
        entity.name = key.toHexString()
        
        arView.scene.anchors.append(entity)
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let nativeValue = try ProtocolParser.decodeStaticField(abiType: SolidityType.bool, data: newValue.makeBytes()) as? Bool else { throw SetFieldError.invalidNativeValue }
        guard let keys = values["key"] as? [Data] else { throw SetFieldError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetFieldError.invalidNativeValue }
        
        let addressStr = address.hex(eip55: true)
        let latestValue = FetchDescriptor<IsAnchorComponent>(
            predicate: #Predicate { $0.key == key && $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(IsAnchorComponent(key: key, worldAddress: address, value: nativeValue, lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}


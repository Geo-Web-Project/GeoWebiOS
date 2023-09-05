//
//  PositionComponent.swift
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
final class PositionComponent {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "PositionComponent")
    
    @Attribute(.unique) var worldKey: String
    var key: Data
    var worldAddress: String
    var x: Float
    var y: Float
    var z: Float
    var lastUpdatedAtBlock: UInt
    
    init(key: Data, worldAddress: EthereumAddress, x: Float, y: Float, z: Float, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress.hex(eip55: true)
        self.x = x
        self.y = y
        self.z = z
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
        
        self.worldKey = "\(worldAddress.hex(eip55: true))/\(key.toHexString())"
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let keys = values["key"] as? [Data] else { throw SetFieldError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetFieldError.invalidNativeValue }

        
        /*
            x: "int16"
            y: "int16"
            z: "int16"
         */
        let dataBytes = newValue.makeBytes()
        let decodeLengths: [Int] = [
            Int(SolidityType.int16.decodeLength!),
            Int(SolidityType.int16.decodeLength!),
            Int(SolidityType.int16.decodeLength!),
        ]
        
        var bytesOffset = 0
        let xData = Array(dataBytes[bytesOffset..<decodeLengths[0]])
        bytesOffset += xData.count
        let yData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[1])])
        bytesOffset += yData.count
        let zData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[2])])
        bytesOffset += zData.count
        
        guard let x = try ProtocolParser.decodeStaticField(abiType: SolidityType.int16, data: xData) as? Int16 else { throw SetFieldError.invalidNativeValue }
        guard let y = try ProtocolParser.decodeStaticField(abiType: SolidityType.int16, data: yData) as? Int16 else { throw SetFieldError.invalidNativeValue }
        guard let z = try ProtocolParser.decodeStaticField(abiType: SolidityType.int16, data: zData) as? Int16 else { throw SetFieldError.invalidNativeValue }
                
        let addressStr = address.hex(eip55: true)
        let latest = FetchDescriptor<PositionComponent>(
            predicate: #Predicate { $0.key == key && $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latest)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(
                PositionComponent(
                    key: key,
                    worldAddress: address,
                    x: Float(x) / 1000,
                    y: Float(y) / 1000,
                    z: Float(z) / 1000,
                    lastUpdatedAtBlock: UInt(blockNumber.quantity)
                )
            )
        }
    }
}


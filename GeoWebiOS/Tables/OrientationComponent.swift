//
//  OrientationComponent.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-09-01.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI
import VarInt
import CID
import Multicodec
import RealityKit

@Model
final class OrientationComponent: ARComponent {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "OrientationComponent")
    
    @Attribute(.unique) var key: Data
    var worldAddress: String
    var x: Float
    var y: Float
    var z: Float
    var w: Float
    var lastUpdatedAtBlock: UInt
    
    init(key: Data, worldAddress: EthereumAddress, x: Float, y: Float, z: Float, w: Float, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress.hex(eip55: true)
        self.x = x
        self.y = y
        self.z = z
        self.w = w
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
    }
    
    func updateARView(_ arView: ARView) {
        let entity = arView.scene.findEntity(named: key.toHexString()) ?? Entity()
        entity.name = key.toHexString()

        var transform = entity.components.has(Transform.self) ? entity.transform : Transform()
        transform.rotation = simd_quatf(ix: x, iy: y, iz: z, r: w)
        entity.components.set(transform)
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let keys = values["key"] as? [Data] else { throw SetFieldError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetFieldError.invalidNativeValue }

        
        /*
            x: "int256"
            y: "int256"
            z: "int256"
            w: "int256
         */
        let dataBytes = newValue.makeBytes()
        let decodeLengths: [Int] = [
            Int(SolidityType.int256.decodeLength!),
            Int(SolidityType.int256.decodeLength!),
            Int(SolidityType.int256.decodeLength!),
            Int(SolidityType.int256.decodeLength!)
        ]
        
        var bytesOffset = 0
        let xData = Array(dataBytes[bytesOffset..<decodeLengths[0]])
        bytesOffset += xData.count
        let yData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[1])])
        bytesOffset += yData.count
        let zData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[2])])
        bytesOffset += zData.count
        let wData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[3])])
        bytesOffset += wData.count
        
        guard let x = try ProtocolParser.decodeStaticField(abiType: SolidityType.int256, data: xData) as? BigInt else { throw SetFieldError.invalidNativeValue }
        guard let y = try ProtocolParser.decodeStaticField(abiType: SolidityType.int256, data: yData) as? BigInt else { throw SetFieldError.invalidNativeValue }
        guard let z = try ProtocolParser.decodeStaticField(abiType: SolidityType.int256, data: zData) as? BigInt else { throw SetFieldError.invalidNativeValue }
        guard let w = try ProtocolParser.decodeStaticField(abiType: SolidityType.int256, data: wData) as? BigInt else { throw SetFieldError.invalidNativeValue }
                
        let addressStr = address.hex(eip55: true)
        let latest = FetchDescriptor<OrientationComponent>(
            predicate: #Predicate { $0.key == key && $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latest)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(
                OrientationComponent(
                    key: key,
                    worldAddress: address,
                    x: Float(x) / pow(10, 18),
                    y: Float(y) / pow(10, 18),
                    z: Float(z) / pow(10, 18),
                    w: Float(w) / pow(10, 18),
                    lastUpdatedAtBlock: UInt(blockNumber.quantity)
                )
            )
        }
    }
}

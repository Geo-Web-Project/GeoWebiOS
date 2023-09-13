//
//  ModelComponent.swift
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

enum ModelEncodingFormat: UInt8, Codable {
    case Glb
    case Usdz
}

@Model
final class ModelComponent {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "ModelComponent")
    
    @Attribute(.unique) var worldKey: String
    var key: Data
    var worldAddress: String
    var encodingFormat: ModelEncodingFormat
    var contentHash: Data
    var lastUpdatedAtBlock: UInt
    
    @Transient
    var contentHashUrl: URL? {
        let contentHashBytes = [UInt8](contentHash)
        let lengthPrefix = uVarInt(contentHashBytes)
        let recBytes = [UInt8](contentHashBytes.dropFirst(lengthPrefix.bytesRead))
        
        let cidVersion = uVarInt(recBytes)
        let cidCodecBytes = [UInt8](recBytes.dropFirst(cidVersion.bytesRead))
        let cidCodec = uVarInt(cidCodecBytes)

        switch Codecs(rawValue: cidCodec.value) {
        case .identity:
            let rawBytes = cidCodecBytes.dropFirst(cidCodec.bytesRead)
            let ext = "usdz"
            return Data(rawBytes).saveToTemporaryURL(ext: ext)
        default:
            do {
                let cid = try CID(recBytes)
                let ext = switch encodingFormat {
                case .Glb:
                    ".glb"
                case .Usdz:
                    ".usdz"
                }
                return URL(string: "https://w3s.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
            } catch {
                return nil
            }
        }
    }
    
    init(key: Data, worldAddress: EthereumAddress, encodingFormat: ModelEncodingFormat, contentHash: Data, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress.hex(eip55: true)
        self.encodingFormat = encodingFormat
        self.contentHash = contentHash
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
        
        self.worldKey = "\(worldAddress.hex(eip55: true))/\(key.toHexString())"
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let keys = values["key"] as? [Data] else { throw SetFieldError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetFieldError.invalidNativeValue }
        
        /*
            encodingFormat: "ModelEncodingFormat"
            contentHash: "bytes"
         */
        let dataBytes = newValue.makeBytes()
        let decodeLengths: [Int] = [
            Int(SolidityType.uint8.decodeLength!),
        ]
        
        var bytesOffset = 0
        let encodingFormatData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[0])])
        bytesOffset += encodingFormatData.count
        
        let (_, fieldByteLengths) = try ProtocolParser.hexToPackedCounter(data: Array(dataBytes[bytesOffset..<(bytesOffset+32)]))
        bytesOffset += 32
        let contentHashData = Array(dataBytes[bytesOffset..<(bytesOffset+Int(fieldByteLengths[0]))])

        guard let encodingFormat = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint8, data: encodingFormatData) as? UInt8 else { throw SetFieldError.invalidNativeValue }
        guard let contentHash = try ProtocolParser.decodeDynamicField(abiType: SolidityType.bytes(length: nil), data: contentHashData) as? Data else { throw SetFieldError.invalidNativeValue }
        
        let addressStr = address.hex(eip55: true)
        let latestValue = FetchDescriptor<ModelComponent>(
            predicate: #Predicate { $0.key == key && $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(ModelComponent(key: key, worldAddress: address, encodingFormat: ModelEncodingFormat(rawValue: encodingFormat)!, contentHash: contentHash, lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}


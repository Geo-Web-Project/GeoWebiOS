//
//  TrackedImageComponent.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-09-04.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI
import VarInt
import CID
import Multicodec

enum ImageEncodingFormat: UInt8, Codable {
    case Jpeg
    case Png
    case Svg
}

@Model
final class TrackedImageComponent {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "TrackedImageComponent")
    
    @Attribute(.unique) var worldKey: String
    var key: Data
    var worldAddress: String
    var imageAsset: Data
    var encodingFormat: ImageEncodingFormat
    var imageWidthInMillimeters: UInt16
    var lastUpdatedAtBlock: UInt
    
    @Transient
    var imageAssetUrl: URL? {
        let contentHashBytes = [UInt8](imageAsset)
        let lengthPrefix = uVarInt(contentHashBytes)
        let recBytes = [UInt8](contentHashBytes.dropFirst(lengthPrefix.bytesRead))
        
        let cidVersion = uVarInt(recBytes)
        let cidCodecBytes = [UInt8](recBytes.dropFirst(cidVersion.bytesRead))
        let cidCodec = uVarInt(cidCodecBytes)

        switch Codecs(rawValue: cidCodec.value) {
        case .identity:
            let rawBytes = cidCodecBytes.dropFirst(cidCodec.bytesRead)
            let ext = switch encodingFormat {
            default:
                ""
            }
            return Data(rawBytes).saveToTemporaryURL(ext: ext)
        default:
            do {
                let cid = try CID(recBytes)
                let ext = switch encodingFormat {
                case .Png:
                    ".png"
                case .Jpeg:
                    ".jpeg"
                case .Svg:
                    ".svg"
                }
                return URL(string: "https://w3s.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
            } catch {
                return nil
            }
        }
    }
    
    init(key: Data, worldAddress: EthereumAddress, imageAsset: Data, encodingFormat: ImageEncodingFormat, imageWidthInMillimeters: UInt16, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress.hex(eip55: true)
        self.imageAsset = imageAsset
        self.encodingFormat = encodingFormat
        self.imageWidthInMillimeters = imageWidthInMillimeters
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
        
        self.worldKey = "\(worldAddress.hex(eip55: true))/\(key.toHexString())"
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let keys = values["key"] as? [Data] else { throw SetFieldError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetFieldError.invalidNativeValue }
        
        /*
            imageWidthInMillimeters: "uint32"
            encodingFormat: "ImageEncodingFormat"
            imageAsset: "bytes"
         */
        let dataBytes = newValue.makeBytes()
        let decodeLengths: [Int] = [
            Int(SolidityType.uint16.decodeLength!),
            Int(SolidityType.uint8.decodeLength!)
        ]
        
        var bytesOffset = 0
        let imageWidthData = Array(dataBytes[bytesOffset..<decodeLengths[0]])
        bytesOffset += imageWidthData.count
        let encodingFormatData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[1])])
        bytesOffset += encodingFormatData.count
        
        let (_, fieldByteLengths) = try ProtocolParser.hexToPackedCounter(data: Array(dataBytes[bytesOffset..<(bytesOffset+32)]))
        bytesOffset += 32
        let imageAssetData = Array(dataBytes[bytesOffset..<(bytesOffset+Int(fieldByteLengths[0]))])

        guard let imageWidth = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint16, data: imageWidthData) as? UInt16 else { throw SetFieldError.invalidNativeValue }
        guard let encodingFormat = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint8, data: encodingFormatData) as? UInt8 else { throw SetFieldError.invalidNativeValue }
        guard let imageAsset = try ProtocolParser.decodeDynamicField(abiType: SolidityType.bytes(length: nil), data: imageAssetData) as? Data else { throw SetFieldError.invalidNativeValue }
        
        
        let addressStr = address.hex(eip55: true)
        let latestValue = FetchDescriptor<TrackedImageComponent>(
            predicate: #Predicate { $0.key == key && $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(TrackedImageComponent(key: key, worldAddress: address, imageAsset: imageAsset, encodingFormat: ImageEncodingFormat(rawValue: encodingFormat)!, imageWidthInMillimeters: imageWidth, lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}

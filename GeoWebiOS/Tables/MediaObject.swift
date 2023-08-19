//
//  MediaObject.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-18.
//

import Foundation
import SwiftData
import Web3
import Web3ContractABI

enum MediaObjectType: UInt8, Codable {
    case Model3D
    case Image
    case Video
    case Audio
}

enum MediaObjectEncodingFormat: UInt8, Codable {
    case Glb
    case Usdz
    case Gif
    case Jpeg
    case Png
    case Svg
    case Mpeg
    case Mp4
}

@Model
final class MediaObject {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "MediaObject")
    
    @Attribute(.unique) var worldAddress: String
    var name: String
    var mediaType: MediaObjectType
    var encodingFormat: MediaObjectEncodingFormat
    var contentSize: UInt64
    var contentHash: Bytes
    var lastUpdatedAtBlock: UInt
    
    init(worldAddress: EthereumAddress, name: String, mediaType: MediaObjectType, encodingFormat: MediaObjectEncodingFormat, contentSize: UInt64, contentHash: Bytes, lastUpdatedAtBlock: UInt) {
        self.worldAddress = worldAddress.hex(eip55: true)
        self.name = name
        self.mediaType = mediaType
        self.encodingFormat = encodingFormat
        self.contentSize = contentSize
        self.contentHash = contentHash
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        
        /*
            contentSize: "uint64"
            mediaType: "MediaObjectType"
            encodingFormat: "EncodingFormat"
            name: "string"
            contentHash: "bytes"
         */
        let dataBytes = newValue.makeBytes()
        let decodeLengths: [Int] = [
            Int(SolidityType.uint64.decodeLength!),
            Int(SolidityType.uint8.decodeLength!),
            Int(SolidityType.uint8.decodeLength!),
        ]
        
        var bytesOffset = 0
        let contentSizeData = Array(dataBytes[bytesOffset..<decodeLengths[0]])
        bytesOffset += contentSizeData.count
        let mediaTypeData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[1])])
        bytesOffset += mediaTypeData.count
        let encodingFormatData = Array(dataBytes[bytesOffset..<(bytesOffset+decodeLengths[2])])
        bytesOffset += encodingFormatData.count
        
        let (_, fieldByteLengths) = try ProtocolParser.hexToPackedCounter(data: Array(dataBytes[bytesOffset..<(bytesOffset+32)]))
        bytesOffset += 32
        let nameData = Array(dataBytes[bytesOffset..<(bytesOffset+Int(fieldByteLengths[0]))])
        bytesOffset += nameData.count
        let contentHashData = Array(dataBytes[bytesOffset..<(bytesOffset+Int(fieldByteLengths[1]))])

        guard let contentSize = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint64, data: contentSizeData) as? UInt64 else { throw SetFieldError.invalidNativeValue }
        guard let mediaType = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint8, data: mediaTypeData) as? UInt8 else { throw SetFieldError.invalidNativeValue }
        guard let encodingFormat = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint8, data: encodingFormatData) as? UInt8 else { throw SetFieldError.invalidNativeValue }
        guard let name = try ProtocolParser.decodeDynamicField(abiType: SolidityType.string, data: nameData) as? String else { throw SetFieldError.invalidNativeValue }
        guard let contentHash = try ProtocolParser.decodeDynamicField(abiType: SolidityType.bytes(length: nil), data: contentHashData) as? Data else { throw SetFieldError.invalidNativeValue }
                
        let addressStr = address.hex(eip55: true)
        let latest = FetchDescriptor<MediaObject>(
            predicate: #Predicate { $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latest)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(MediaObject(worldAddress: address, name: name, mediaType: MediaObjectType(rawValue: mediaType)!, encodingFormat: MediaObjectEncodingFormat(rawValue: encodingFormat)!, contentSize: contentSize, contentHash: contentHash.makeBytes(), lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}

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
import VarInt
import CID
import Multicodec

enum MediaObjectType: UInt8, Codable {
    case Image = 0
    case Audio = 1
    case Video = 2
    case Model3D = 3
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
    case Mp3
}

@Model
final class MediaObject {
    enum SetFieldError: Error {
        case invalidData
        case invalidNativeType
        case invalidNativeValue
    }

    static let tableId: TableId = TableId(namespace: "geoweb", name: "MediaObject")
    
    @Attribute(.unique) var worldKey: String
    var key: Data
    var worldAddress: String
    var name: String
    var mediaType: MediaObjectType?
    var encodingFormat: MediaObjectEncodingFormat?
    var contentSize: UInt64
    var contentHash: Data
    var lastUpdatedAtBlock: UInt
    
    @Transient
    var contentUrl: URL? {
        let contentHashBytes = [UInt8](contentHash)
        let lengthPrefix = uVarInt(contentHashBytes)
        let recBytes = [UInt8](contentHashBytes.dropFirst(lengthPrefix.bytesRead))
        
        let cidVersion = uVarInt(recBytes)
        let cidCodecBytes = [UInt8](recBytes.dropFirst(cidVersion.bytesRead))
        let cidCodec = uVarInt(cidCodecBytes)

        switch Codecs(rawValue: cidCodec.value) {
        case .identity:
            let rawBytes = cidCodecBytes.dropFirst(cidCodec.bytesRead)
            let ext = switch encodingFormat {
            case .Mp4:
                "mp4"
            case .Usdz:
                "usdz"
            case .Glb:
                "glb"
            case .Mp3:
                "mp3"
            default:
                ""
            }
            return Data(rawBytes).saveToTemporaryURL(ext: ext)
        default:
            do {
                let cid = try CID(recBytes)
                let ext = switch encodingFormat {
                case .Usdz:
                    ".usdz"
                case .Glb:
                    ".glb"
                case .Png:
                    ".png"
                case .Mp3:
                    ".mp3"
                case .Mp4:
                    ".mp4"
                default:
                    ""
                }
                return URL(string: "https://w3s.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
            } catch {
                return nil
            }
        }
    }
    
    init(key: Data, worldAddress: EthereumAddress, name: String, mediaType: MediaObjectType?, encodingFormat: MediaObjectEncodingFormat?, contentSize: UInt64, contentHash: Data, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress.hex(eip55: true)
        self.name = name
        self.mediaType = mediaType
        self.encodingFormat = encodingFormat
        self.contentSize = contentSize
        self.contentHash = contentHash
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
        
        self.worldKey = "\(worldAddress.hex(eip55: true))/\(key.toHexString())"
    }
    
    static func setRecord(modelContext: ModelContext, address: EthereumAddress, values: [String: Any], blockNumber: EthereumQuantity) throws {
        guard let newValue = values["data"] as? Data else { throw SetFieldError.invalidData }
        guard let keys = values["key"] as? [Data] else { throw SetFieldError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetFieldError.invalidNativeValue }

        
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
            predicate: #Predicate { $0.key == key && $0.worldAddress == addressStr }
        )
        let results = try modelContext.fetch(latest)
        let latestBlockNumber = results.count > 0 ? results[0].lastUpdatedAtBlock : nil
        
        if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            modelContext.insert(MediaObject(key: key, worldAddress: address, name: name, mediaType: MediaObjectType(rawValue: mediaType), encodingFormat: MediaObjectEncodingFormat(rawValue: encodingFormat), contentSize: contentSize, contentHash: contentHash, lastUpdatedAtBlock: UInt(blockNumber.quantity)))
        }
    }
}

extension Data {
    func saveToTemporaryURL(ext: String) -> URL? {
        do {
            // Create a temporary file URL
            let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
            let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(ext)
            
            // Write the data to the temporary file URL
            try self.write(to: temporaryFileURL, options: .atomic)
            
            return temporaryFileURL
        } catch {
            print("Error saving data to temporary URL: \(error)")
            return nil
        }
    }
}

class MediaObjectFixtures {
    static var image: MediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "sample-logo", withExtension: "png")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))

        return MediaObject(
            key: Data(),
            worldAddress: try! EthereumAddress(hex: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352", eip55: true),
            name: "Example image",
            mediaType: .Image,
            encodingFormat: .Png,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
    
    static var model: MediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "robot", withExtension: "usdz")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))
        
        return MediaObject(
            key: Data(),
            worldAddress: try! EthereumAddress(hex: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352", eip55: true),
            name: "Example model",
            mediaType: .Model3D,
            encodingFormat: .Usdz,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
    
    static var video: MediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "video", withExtension: "mp4")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))

        return MediaObject(
            key: Data(),
            worldAddress: try! EthereumAddress(hex: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352", eip55: true),
            name: "Example video",
            mediaType: .Video,
            encodingFormat: .Mp4,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
    
    static var audio: MediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "audio", withExtension: "mp3")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))

        return MediaObject(
            key: Data(),
            worldAddress: try! EthereumAddress(hex: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352", eip55: true),
            name: "Example audio",
            mediaType: .Audio,
            encodingFormat: .Mp3,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
}

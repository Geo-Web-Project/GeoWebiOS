//
//  ImageCom.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import Foundation
import RealityKit
import VarInt
import CID
import Multicodec
import SwiftData
import SwiftMUD
import Web3
import Web3ContractABI
import CryptoSwift

enum ImageEncodingFormat: UInt8, Codable {
    case Jpeg
    case Png
    case Svg
}

@Model
final class ImageCom: Component, Record {
    var table: Table?
    
    @Attribute(.unique) var uniqueKey: String
    var lastUpdatedAtBlock: UInt

    var key: Data
    
    var encodingFormat: ImageEncodingFormat?
    var physicalWidthInMillimeters: UInt64?
    var contentHash: Data? {
        didSet {
            guard let contentHash = contentHash else {
                contentUrl = nil
                return
            }
            
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
                default:
                    ""
                }
                contentUrl = Data(rawBytes).saveToTemporaryURL(ext: ext)
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
                    default:
                        ""
                    }
                    contentUrl = URL(string: "https://dweb.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
                } catch {
                    contentUrl = nil
                }
            }
        }
    }
    
    @Transient
    var contentUrl: URL?
    
    init(uniqueKey: String, lastUpdatedAtBlock: UInt, key: Data, encodingFormat: ImageEncodingFormat, physicalWidthInMillimeters: UInt64, contentHash: Data) {
        self.uniqueKey = uniqueKey
        self.lastUpdatedAtBlock = lastUpdatedAtBlock

        self.key = key
        self.encodingFormat = encodingFormat
        self.physicalWidthInMillimeters = physicalWidthInMillimeters
        self.contentHash = contentHash
    }
    
    static func setRecord(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        
        guard let staticData = values["staticData"] as? Data else { throw SetRecordError.invalidData }
        let staticDataBytes = staticData.makeBytes()
        let staticDataLengths: [Int] = [
            Int(SolidityType.uint8.decodeLength!),
            Int(SolidityType.uint64.decodeLength!)
        ]
        
        var bytesOffset = 0
        let encodingFormatData = Array(staticDataBytes[bytesOffset..<staticDataLengths[0]])
        bytesOffset += encodingFormatData.count
        let physicalWidthData = Array(staticDataBytes[bytesOffset...])
        bytesOffset += physicalWidthData.count
        
        guard let encodingFormat = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint8, data: encodingFormatData) as? UInt8 else { throw SetRecordError.invalidNativeValue }
        guard let physicalWidthInMillimeters = try ProtocolParser.decodeStaticField(abiType: SolidityType.uint64, data: physicalWidthData) as? UInt64 else { throw SetRecordError.invalidNativeValue }
        guard let imageEncodingFormat = ImageEncodingFormat(rawValue: encodingFormat) else { throw SetRecordError.invalidData }
        
        guard let encodedLengthsData = values["encodedLengths"] as? Data else { throw SetRecordError.invalidData }
        guard let encodedLengthsBytes = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: encodedLengthsData.makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }
        let (_, encodedLengths) = try ProtocolParser.hexToPackedCounter(data: encodedLengthsBytes.makeBytes())
        
        guard let dynamicData = values["dynamicData"] as? Data else { throw SetRecordError.invalidData }
        
        let dataBytes = dynamicData.makeBytes()
        bytesOffset = 0
        let contentHashData = Array(dataBytes[bytesOffset..<Int(encodedLengths[0])])
        
        guard let contentHash = try ProtocolParser.decodeDynamicField(abiType: SolidityType.bytes(length: 64), data: contentHashData) as? Data else { throw SetRecordError.invalidNativeValue }

        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
        
        let latestValue = FetchDescriptor<ImageCom>(
            predicate: #Predicate { $0.uniqueKey == uniqueKey }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.first?.lastUpdatedAtBlock
        
        if let existingRecord = results.first {
            existingRecord.encodingFormat = imageEncodingFormat
            existingRecord.physicalWidthInMillimeters = physicalWidthInMillimeters
            existingRecord.contentHash = contentHash
            existingRecord.lastUpdatedAtBlock = UInt(blockNumber.quantity)
        } else if latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity {
            let record = ImageCom(
                uniqueKey: uniqueKey,
                lastUpdatedAtBlock: UInt(blockNumber.quantity),
                key: key,
                encodingFormat: imageEncodingFormat,
                physicalWidthInMillimeters: physicalWidthInMillimeters,
                contentHash: contentHash
            )
            record.table = table
            modelContext.insert(record)
        }
    }
    
    static func spliceStaticData(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {

    }
    
    static func spliceDynamicData(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {

    }
    
    static func deleteRecord(modelContext: ModelContext, table: Table, values: [String : Any], blockNumber: EthereumQuantity) throws {
        guard let keys = values["keyTuple"] as? [Data] else { throw SetRecordError.invalidData }
        guard let key = try ProtocolParser.decodeStaticField(abiType: SolidityType.bytes(length: 32), data: keys[0].makeBytes()) as? Data else { throw SetRecordError.invalidNativeValue }

        let digest: Array<UInt8> = Array(table.namespace!.world!.uniqueKey.hexToBytes() + table.namespace!.namespaceId.hexToBytes() + table.tableName.makeBytes() + key.makeBytes())
        let uniqueKey = SHA3(variant: .keccak256).calculate(for: digest).toHexString()
        
        let latestValue = FetchDescriptor<ImageCom>(
            predicate: #Predicate { $0.uniqueKey == uniqueKey }
        )
        let results = try modelContext.fetch(latestValue)
        let latestBlockNumber = results.first?.lastUpdatedAtBlock
        
        if let existingRecord = results.first, (latestBlockNumber == nil || latestBlockNumber! < blockNumber.quantity) {
            modelContext.delete(existingRecord)
        }
    }
}

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

enum ImageEncodingFormat: UInt8, Codable {
    case Jpeg
    case Png
    case Svg
}

class ImageCom: Component {
    var physicalWidthInMillimeters: UInt64
    var contentHash: Data
    var encodingFormat: ImageEncodingFormat
    
    var imageAssetUrl: URL? {
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
                return URL(string: "https://dweb.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
            } catch {
                return nil
            }
        }
    }
    
    init(physicalWidthInMillimeters: UInt64, contentHash: Data, encodingFormat: ImageEncodingFormat) {
        self.physicalWidthInMillimeters = physicalWidthInMillimeters
        self.contentHash = contentHash
        self.encodingFormat = encodingFormat
    }
}

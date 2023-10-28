//
//  ModelCom.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import Foundation
import RealityKit
import VarInt
import CID
import Multicodec

enum ModelEncodingFormat: UInt8, Codable {
    case Glb
    case Usdz
}

class ModelCom: Component {
    var contentHash: Data
    var encodingFormat: ModelEncodingFormat
    
    lazy var contentUrl: URL? = {
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
            case .Glb:
                ".glb"
            case .Usdz:
                ".usdz"
            }
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
                return URL(string: "https://dweb.link/ipfs/\(cid.toBaseEncodedString)?filename=\(cid.toBaseEncodedString)\(ext)")
            } catch {
                return nil
            }
        }
    }()
    
    init(contentHash: Data, encodingFormat: ModelEncodingFormat) {
        self.contentHash = contentHash
        self.encodingFormat = encodingFormat
    }
}

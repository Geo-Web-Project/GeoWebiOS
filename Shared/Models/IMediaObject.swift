//
//  IMediaObject.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-09-14.
//

import Foundation
import VarInt

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

protocol IMediaObject {
    var key: Data { get }
    var worldAddress: String { get }
    var name: String { get }
    var mediaType: MediaObjectType? { get }
    var encodingFormat: MediaObjectEncodingFormat? { get }
    var contentSize: UInt64 { get }
    var contentHash: Data { get }
    var lastUpdatedAtBlock: UInt { get }
    var contentUrl: URL? { get }
}

struct StubMediaObject: IMediaObject {
    var key: Data
    var worldAddress: String
    var name: String
    var mediaType: MediaObjectType?
    var encodingFormat: MediaObjectEncodingFormat?
    var contentSize: UInt64
    var contentHash: Data
    var lastUpdatedAtBlock: UInt
    var contentUrl: URL? = URL(fileURLWithPath: "")
    
    init(key: Data, worldAddress: String, name: String, mediaType: MediaObjectType?, encodingFormat: MediaObjectEncodingFormat?, contentSize: UInt64, contentHash: Data, lastUpdatedAtBlock: UInt) {
        self.key = key
        self.worldAddress = worldAddress
        self.name = name
        self.mediaType = mediaType
        self.encodingFormat = encodingFormat
        self.contentSize = contentSize
        self.contentHash = contentHash
        self.lastUpdatedAtBlock = lastUpdatedAtBlock
    }
}

class StubMediaObjectFixtures {
    static var image: StubMediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "sample-logo", withExtension: "png")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))

        return StubMediaObject(
            key: Data(),
            worldAddress: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352",
            name: "Example image",
            mediaType: .Image,
            encodingFormat: .Png,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
    
    static var model: StubMediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "robot", withExtension: "usdz")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))
        
        return StubMediaObject(
            key: Data(),
            worldAddress: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352",
            name: "Example model",
            mediaType: .Model3D,
            encodingFormat: .Usdz,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
    
    static var video: StubMediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "video", withExtension: "mp4")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))

        return StubMediaObject(
            key: Data(),
            worldAddress: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352",
            name: "Example video",
            mediaType: .Video,
            encodingFormat: .Mp4,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
    
    static var audio: StubMediaObject {
        let contentData = try! Data(contentsOf: Bundle.main.url(forResource: "audio", withExtension: "mp3")!)
        let contentHash = putUVarInt(0xe3) + (putUVarInt(0x01) + (putUVarInt(0x00) + contentData))

        return StubMediaObject(
            key: Data(),
            worldAddress: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352",
            name: "Example audio",
            mediaType: .Audio,
            encodingFormat: .Mp3,
            contentSize: 10,
            contentHash: contentHash,
            lastUpdatedAtBlock: 0
        )
    }
}

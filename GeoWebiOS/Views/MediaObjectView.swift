//
//  MediaObjectView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-22.
//

import SwiftUI
import SwiftData
import Web3

struct MediaObjectView: View {
    var mediaObject: MediaObject

    var body: some View {
        switch (mediaObject.mediaType, mediaObject.contentUrl) {
        case (_, let contentUrl) where contentUrl == nil:
            ProgressView()
        case (.Image, let contentUrl):
            try? Image(url: contentUrl!)
        case (.Model3D, let contentUrl):
            ModelSceneView(modelURL: contentUrl!)
        default:
            Text("Unknown media object")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let imageObject = MediaObject(
        key: "0x".makeBytes(),
        worldAddress: try! EthereumAddress(hex: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352", eip55: true),
        name: "Example item",
        mediaType: .Image,
        encodingFormat: .Png,
        contentSize: 10,
        contentHash: "0x".makeBytes(),
        lastUpdatedAtBlock: 0
    )
    imageObject.contentUrl = Bundle.main.url(forResource: "sample-favicon", withExtension: "png")
    
    return MediaObjectView(mediaObject: imageObject)
}

#Preview {
    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let modelObject = MediaObject(
        key: "0x".makeBytes(),
        worldAddress: try! EthereumAddress(hex: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352", eip55: true),
        name: "Example item",
        mediaType: .Model3D,
        encodingFormat: .Usdz,
        contentSize: 10,
        contentHash: "0x".makeBytes(),
        lastUpdatedAtBlock: 0
    )
    modelObject.contentUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!)
    
    return MediaObjectView(mediaObject: modelObject)
}

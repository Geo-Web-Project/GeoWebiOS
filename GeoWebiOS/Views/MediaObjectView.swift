//
//  MediaObjectView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-22.
//

import SwiftUI
import SwiftData
import Web3
import CID

struct MediaObjectView: View {
    var mediaObject: MediaObject

    var body: some View {
        switch (mediaObject.mediaType, mediaObject.contentUrl) {
        case (_, let contentUrl) where contentUrl == nil:
            ProgressView()
        case (.Image, let contentUrl):
            VStack {
                AsyncImage(url: contentUrl!) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .padding()
                
                Text(mediaObject.name)
            }
        case (.Model3D, let contentUrl):
            ModelSceneView(modelURL: contentUrl!)
        default:
            Text("Unknown media object")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    return MediaObjectView(mediaObject: MediaObjectFixtures.image)
}

#Preview {
    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    return MediaObjectView(mediaObject: MediaObjectFixtures.model)
}

//
//  MediaGalleryView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-22.
//

import SwiftUI
import SwiftData
import Web3

struct MediaGalleryView: View {
    var mediaObjects: [MediaObject]
    @Binding var isPresenting: Bool

    var body: some View {
        TabView {
            ForEach(mediaObjects) { mediaObject in
                MediaObjectView(mediaObject: mediaObject)
            }
        }
        .navigationTitle("Media Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(.page)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Label("Media Gallery", systemImage: "photo.on.rectangle.angled")
                    .labelStyle(.titleAndIcon)
                    .font(.headline)
            }
            ToolbarItem {
                Button(action: {
                    isPresenting = false
                }, label: {
                    Image(systemName: "xmark")
                })
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let object = MediaObject(
        key: "0x".makeBytes(),
        worldAddress: try! EthereumAddress(hex: "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352", eip55: true),
        name: "Example item",
        mediaType: .Image,
        encodingFormat: .Png,
        contentSize: 10,
        contentHash: "0x".makeBytes(),
        lastUpdatedAtBlock: 0
    )
    object.contentUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "sample-favicon", ofType: "png")!)
    
    return NavigationStack {
        MediaGalleryView(mediaObjects: [object], isPresenting: Binding.constant(true))
    }
}

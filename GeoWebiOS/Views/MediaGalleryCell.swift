//
//  MediaGalleryCell.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-22.
//

import SwiftUI
import Web3
import SwiftData

struct MediaGalleryCell: View {
    var mediaObjects: [MediaObject]
    @State var isPresentingMediaGallery: Bool = false

    var body: some View {
        Button(action: {
            isPresentingMediaGallery = true
        }, label: {
            GroupBox(label:
                        Label("Media Gallery", systemImage: "photo.on.rectangle.angled")
                .font(.caption)
                .textCase(.uppercase)
            ) {
                TabView {
                    ForEach(mediaObjects) { mediaObject in
                        MediaObjectView(mediaObject: mediaObject)
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                .tabViewStyle(.page)
            }
        })
        .sheet(isPresented: $isPresentingMediaGallery) {
            NavigationStack {
                MediaGalleryView(mediaObjects: mediaObjects, isPresenting: $isPresentingMediaGallery)
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
    
    return MediaGalleryCell(mediaObjects: [object])
        .padding()
        .modelContainer(container)
}

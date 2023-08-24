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
                            .padding(.bottom, 50)
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

    return MediaGalleryCell(mediaObjects: [MediaObjectFixtures.image, MediaObjectFixtures.image])
        .padding()
        .modelContainer(container)
}

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
    
    return NavigationStack {
        MediaGalleryView(mediaObjects: [MediaObjectFixtures.image], isPresenting: Binding.constant(true))
    }
}

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
    @Binding var selectedObject: Int

    var body: some View {
        TabView(selection: $selectedObject) {
            ForEach(Array(mediaObjects.enumerated()), id: \.offset) { index, mediaObject in
                MediaObjectView(mediaObject: mediaObject)
                    .padding(.bottom, 50)
                    .tag(index)
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
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.primary)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.primary).withAlphaComponent(0.2)
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    return NavigationStack {
        MediaGalleryView(mediaObjects: [MediaObjectFixtures.image, MediaObjectFixtures.image], isPresenting: Binding.constant(true), selectedObject: Binding.constant(0))
    }
}

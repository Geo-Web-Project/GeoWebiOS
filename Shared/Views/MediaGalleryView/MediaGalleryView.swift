//
//  MediaGalleryView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI

struct MediaGalleryView: View {
    @Binding var isPresenting: Bool

    var body: some View {
        TabView {
            ModelSceneView(modelURL: URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!),
                           qLAvailable: true)
                .padding(.bottom, 40)
            Image("sample-favicon")
                .padding()
            Image("sample-favicon")
                .padding()
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
    NavigationStack {
        MediaGalleryView(isPresenting: Binding.constant(true))
    }
}

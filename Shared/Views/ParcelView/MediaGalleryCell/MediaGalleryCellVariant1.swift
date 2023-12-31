//
//  MediaGalleryCellVariant1.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI

struct MediaGalleryCellVariant1: View {
    @State var isPresentingMediaGallery: Bool = false

    var body: some View {
        Button(action: {
            isPresentingMediaGallery = true
        }, label: {
            GroupBox(label:
                        Label("Media Gallery", systemImage: "photo.on.rectangle.angled")
                .font(.subheadline)
            ) {
                TabView {
                    ModelSceneView(mediaObject: StubMediaObjectFixtures.image)
                        .padding(.bottom, 40)
                    
                    Image("sample-favicon")
                        .padding()
                    
                    Image("sample-favicon")
                        .padding()
                }
                .aspectRatio(1.0, contentMode: .fit)
                .tabViewStyle(.page)
            }
        })
        .sheet(isPresented: $isPresentingMediaGallery) {
            NavigationStack {
                MediaGalleryView(isPresenting: $isPresentingMediaGallery)
            }
        }
    }
}

#Preview {
    MediaGalleryCellVariant1()
        .padding()
}

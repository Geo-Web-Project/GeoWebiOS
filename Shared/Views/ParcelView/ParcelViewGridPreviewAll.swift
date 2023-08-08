//
//  ParcelViewGridLarge.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI

struct ParcelViewGridPreviewAll: View {
    var body: some View {
        ScrollView {
            Grid(verticalSpacing: 20) {
                Section("EnterARButton") {
                    EnterARButton()
                }
                
                Section("WebViewCell") {
                    WebViewCellVariant1(uri: "https://immersive-web.github.io")
                    WebViewCellVariant2(uri: "https://immersive-web.github.io")
                    WebViewCellVariant3(uri: "https://immersive-web.github.io")
                }
                
                Section("MediaGalleryCell") {
                    MediaGalleryCellVariant1()
                    MediaGalleryCellVariant2()
                }
                
                Section("MapViewCell") {
                    MapViewCellVariant1()
                    MapViewCellVariant2()
                }
                
                Section("Grid") {
                    GridRow {
                        WebViewCellVariant1(uri: "https://immersive-web.github.io")
                        MapViewCellVariant1()
                    }
                    GridRow {
                        WebViewCellVariant2(uri: "https://immersive-web.github.io")
                        MapViewCellVariant2()
                    }
                }
            
                Spacer()
            }
            .padding()
            .backgroundStyle(.thinMaterial)
        }
        .toolbarBackground(Color("BackgroundColor"))
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    NavigationStack {
        ParcelViewGridPreviewAll()
    }
}

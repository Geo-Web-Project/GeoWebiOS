//
//  ParcelViewInfo.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-16.
//

import SwiftUI

struct ParcelViewInfo: View {
    @State private var isPresentingMapView = false
    
    var body: some View {
        ScrollView {
            Grid {
                ParcelMetadataView()
                
                WebViewCell(uri: "https://immersive-web.github.io")
                    .frame(height: 200)
                                
                AugmentCell()
                
                Spacer()
            }.padding()
        }
        .navigationTitle("Parcel Name")
        .navigationBarTitleDisplayMode(.large)
        .background(Color("BackgroundColor"))
        .fullScreenCover(isPresented: $isPresentingMapView) {
            FullMapView(isPresenting: $isPresentingMapView)
        }
    }
}

#Preview {
    NavigationStack {
        ParcelViewInfo()
    }
}

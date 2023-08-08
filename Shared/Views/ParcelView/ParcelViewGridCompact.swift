//
//  ParcelViewGrid.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-27.
//

import SwiftUI

struct ParcelViewGridCompact: View {
    @State var isARAvailable: Bool
    @State private var isPresentingMapView = false
    
    var body: some View {
        ScrollView {
            Grid {
                if (isARAvailable) {
                    EnterARButton()
                }
                
                GridRow {
                    WebViewCell(uri: "https://immersive-web.github.io")
                    
                    MapViewCell()
                }
                
                MediaGalleryCell()
                
                Spacer()
            }.padding()
        }
        .navigationTitle("Parcel Name")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color("BackgroundColor"))
        .background(Color("BackgroundColor"))
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button(action: {
                        isPresentingMapView = true
                    }, label: {
                        Image(systemName: "map")
                    })
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "list.bullet")
                    })
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentingMapView) {
            FullMapView(isPresenting: $isPresentingMapView)
        }
    }
}

#Preview {
    NavigationStack {
        ParcelViewGridCompact(isARAvailable: true)
    }
}

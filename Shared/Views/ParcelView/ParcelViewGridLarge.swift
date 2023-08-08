//
//  ParcelViewGridLarge.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI

struct ParcelViewGridLarge: View {
    @State var isARAvailable: Bool
    @State private var isPresentingMapView = false
    @State private var isPresentingParcelListView = false
    @State private var refresh = UUID()

    var body: some View {
        if isPresentingParcelListView {
            ParcelListView(isPresenting: $isPresentingParcelListView)
                .transition(.scale(2))
            } else {
            ScrollView {
                Grid(verticalSpacing: 20) {
                    HStack {
                        Label("Nearby", systemImage: "location.fill")
                            .font(.subheadline)
                        Spacer()
                    }

                    if (isARAvailable) {
                        EnterARButton()
                    }
                    
                    WebViewCell(uri: "https://immersive-web.github.io")
                    
                    MediaGalleryCell()
                    
                    MapViewCell()
                
                    Spacer()
                }
                .backgroundStyle(.thinMaterial)
                .padding()
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
                        Button(action: {
                            withAnimation(.snappy(duration: 0.2)) {
                                isPresentingParcelListView = true
                            }
                        }, label: {
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
}

#Preview {
    NavigationStack {
        ParcelViewGridLarge(isARAvailable: true)
    }
}

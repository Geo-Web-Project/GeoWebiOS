//
//  ParcelViewGridLarge.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI

struct ParcelViewGridLarge: View {
    @Binding var isPresentingWorldView: Bool
    @State var isARAvailable: Bool
    @State private var isPresentingMapView = false
    @State private var refresh = UUID()

    var body: some View {
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
                            isPresentingWorldView = false
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

#Preview {
    NavigationStack {
        ParcelViewGridLarge(isPresentingWorldView: Binding.constant(true), isARAvailable: true)
    }
}

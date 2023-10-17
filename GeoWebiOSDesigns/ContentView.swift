//
//  ContentView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Parcel View") {
                    NavigationLink(destination: ParcelViewGridCompact(isARAvailable: true)) {
                        Text("Compact")
                    }
                    NavigationLink(destination: ParcelViewGridLarge(isPresentingWorldView: Binding.constant(true), isARAvailable: true)) {
                        Text("Large")
                    }
                    NavigationLink(destination: ParcelViewGridPreviewAll()) {
                        Text("All")
                    }
                    NavigationLink(destination: ParcelViewInfo()) {
                        Text("Info")
                    }
                }
                Section("Parcel List View") {
                    NavigationLink(destination: WorldListItemView1(hasWebContent: true, hasMediaGallery: true, hasARContent: true)) {
                        Text("Item")
                    }
                    NavigationLink(destination: {
                        ParcelListView()
                    }) {
                        Text("List1")
                    }
                    NavigationLink(destination: {
                        ParcelListView2(isPresenting: Binding.constant(true))
                    }) {
                        Text("List2")
                    }
                    NavigationLink(destination: {
                        ParcelListView3()
                    }) {
                        Text("List3")
                    }
                }
                Section("Components") {
                    NavigationLink(destination: EnterARButton()) {
                        Text("EnterARButton")
                    }
                    NavigationLink(destination: FullMapView(isPresenting: Binding.constant(true))) {
                        Text("FullMapView")
                    }
                    NavigationLink(destination: MediaGalleryView(isPresenting: Binding.constant(true))) {
                        Text("MediaGalleryView")
                    }
                }
                
                Section("ARViews") {
//                    NavigationLink(destination: ImageCaptureARView()) {
//                        Text("ImageCaptureARView")
//                    }
//                    NavigationLink(destination: GeoPublishARView()) {
//                        Text("GeoPublishARView")
//                    }
                    NavigationLink(destination: ImageTargetARView()) {
                        Text("ImageTargetARView")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

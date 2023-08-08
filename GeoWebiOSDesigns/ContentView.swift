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
                    NavigationLink(destination: ParcelViewGridLarge(isARAvailable: true)) {
                        Text("Large")
                    }
                    NavigationLink(destination: ParcelViewGridPreviewAll()) {
                        Text("All")
                    }
                }
                Section("Parcel List View") {
                    NavigationLink(destination: ParcelListItemView(hasWebContent: true, hasMediaGallery: true, hasARContent: true)) {
                        Text("Item")
                    }
                    NavigationLink(destination: {
                        ParcelListView(isPresenting: Binding.constant(true))
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
                    NavigationLink(destination:             FullMapView(isPresenting: Binding.constant(true))) {
                        Text("FullMapView")
                    }
                    NavigationLink(destination: MediaGalleryView(isPresenting: Binding.constant(true))) {
                        Text("MediaGalleryView")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

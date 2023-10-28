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
                            .fontWeight(.bold)
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
                    NavigationLink(destination: {
                        AugmentListView()
                    }) {
                        Text("AugmentListView")
                            .fontWeight(.bold)
                    }
                }
                
                Section("AugmentCell") {
                    NavigationLink(destination: AugmentCellVariant1()) {
                        Text("AugmentCellVariant1")
                            .fontWeight(.bold)
                    }
                    NavigationLink(destination: AugmentCellVariant2()) {
                        Text("AugmentCellVariant2")
                            .fontWeight(.bold)
                    }
                    NavigationLink(destination: AugmentCellVariant3()) {
                        Text("AugmentCellVariant3")
                            .fontWeight(.bold)
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
//                    NavigationLink(destination: ModelAugmentPreview()) {
//                        Text("ModelAugmentPreview")
//                    }
                    NavigationLink(destination: ImageAugmentPreview()) {
                        Text("ImageAugmentPreview")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

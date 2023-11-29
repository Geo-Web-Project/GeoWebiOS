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
                Section("Tab Views and Bars") {
                    NavigationLink(destination: {
                        ZStack {
                            Color.orange
                                .ignoresSafeArea()
                            TabBarEllipse1()
                        }
                    }) {
                        Text("TabBarEllipse1")
                            .fontWeight(.bold)
                    }
                    NavigationLink(destination: {
                        ZStack {
                            Color.orange
                                .ignoresSafeArea()
                            TabBarEllipse(selectedTab: Binding.constant(0))
                        }
                    }) {
                        Text("TabBarEllipse2")
                            .fontWeight(.bold)
                    }
                    NavigationLink(destination: {
                        TabSheetView()
                    }) {
                        Text("TabSheetView")
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
                    }
                }
                
                Section("AugmentCell") {
                    NavigationLink(destination: AugmentCellVariant1()) {
                        Text("AugmentCellVariant1")
                    }
                    NavigationLink(destination: AugmentCellVariant2()) {
                        Text("AugmentCellVariant2")
                    }
                    NavigationLink(destination: AugmentCellVariant3()) {
                        Text("AugmentCellVariant3")
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
//                    NavigationLink(destination: ModelAugmentPreview()
//                        .modelContainer(for: [
//                            PositionCom.self,
//                            ModelCom.self,
//                        ], inMemory: true)) {
//                        Text("ModelAugmentPreview")
//                            .fontWeight(.bold)
//                    }
//                    NavigationLink(destination: ImageAugmentPreview()) {
//                        Text("ImageAugmentPreview")
//                            .fontWeight(.bold)
//                    }
                    NavigationLink(destination: GeoModelAugmentPreview()
                        .modelContainer(for: [
                            PositionCom.self,
                            ModelCom.self,
                        ], inMemory: true)) {
                        Text("GeoModelAugmentPreview")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

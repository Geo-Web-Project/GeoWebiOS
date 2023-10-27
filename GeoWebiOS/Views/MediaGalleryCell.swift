////
////  MediaGalleryCell.swift
////  GeoWebiOS
////
////  Created by Cody Hatfield on 2023-08-22.
////
//
//import SwiftUI
//import Web3
//import SwiftData
//
//struct MediaGalleryCell: View {
//    var mediaObjects: [MediaObject]
//    @State var isPresentingMediaGallery: Bool = false
//    
//    @State private var selectedObject: Int = 0
//    
//    var body: some View {
//        Button(action: {
//            isPresentingMediaGallery = true
//        }, label: {
//            GroupBox(label:
//                        Label("Media Gallery", systemImage: "photo.on.rectangle.angled")
//                .font(.caption)
//                .textCase(.uppercase)
//            ) {
//                TabView(selection: $selectedObject) {
//                    ForEach(Array(mediaObjects.enumerated()), id: \.offset) { index, mediaObject in
//                        MediaObjectView(mediaObject: mediaObject, showInteraction: false)
//                            .padding(.bottom, 50)
//                            .allowsHitTesting(false)
//                            .tag(index)
//                    }
//                }
//                .aspectRatio(1.0, contentMode: .fit)
//                .tabViewStyle(.page)
//            }
//        })
//        .sheet(isPresented: $isPresentingMediaGallery) {
//            NavigationStack {
//                MediaGalleryView(mediaObjects: mediaObjects, isPresenting: $isPresentingMediaGallery, selectedObject: $selectedObject)
//            }
//        }
//        .onAppear {
//            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.primary)
//            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.primary).withAlphaComponent(0.2)
//        }
//    }
//}
//
//#Preview {
//    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//
//    return MediaGalleryCell(mediaObjects: [MediaObjectFixtures.image, MediaObjectFixtures.image])
//        .padding()
//        .modelContainer(container)
//}

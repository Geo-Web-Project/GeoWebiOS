////
////  MediaObjectView.swift
////  GeoWebiOS
////
////  Created by Cody Hatfield on 2023-08-22.
////
//
//import SwiftUI
//import SwiftData
//import Web3
//import CID
//import AVKit
//
//struct MediaObjectView: View {
//    var mediaObject: MediaObject
//    var showInteraction: Bool = true
//
//    var body: some View {
//        VStack {
//            switch (mediaObject.mediaType, mediaObject.contentUrl) {
//            case (_, let contentUrl) where contentUrl == nil:
//                Spacer()
//                ProgressView()
//                Spacer()
//            case (.Image, let contentUrl):
//                Spacer()
//                AsyncImage(url: contentUrl!) { image in
//                    image.resizable()
//                } placeholder: {
//                    ProgressView()
//                }
//                .aspectRatio(contentMode: .fit)
//                .padding()
//                Spacer()
//            case (.Model3D, _):
//                Spacer()
//                ModelSceneView(mediaObject: mediaObject)
//                Spacer()
//            case (.Video, let contentUrl):
//                Spacer()
//                AVObjectView(url: contentUrl!, showPlayButton: showInteraction)
//                Spacer()
//            case (.Audio, let contentUrl):
//                Spacer()
//                AVObjectView(url: contentUrl!, showPlayButton: showInteraction)
//                Spacer()
//            default:
//                Text("Unknown media object")
//            }
//            
//            Text(mediaObject.name)
//        }
//    }
//}
//
//#Preview {
//    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//    
//    return MediaObjectView(mediaObject: MediaObjectFixtures.image)
//}
//
//#Preview {
//    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//
//    return MediaObjectView(mediaObject: MediaObjectFixtures.model)
//}
//
//#Preview {
//    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//
//    return MediaObjectView(mediaObject: MediaObjectFixtures.video)
//}
//
//#Preview {
//    let container = try! ModelContainer(for: MediaObject.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//
//    return MediaObjectView(mediaObject: MediaObjectFixtures.audio)
//}

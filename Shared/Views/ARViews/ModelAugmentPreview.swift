////
////  ModelAugmentPreview.swift
////  GeoWebiOSDesigns
////
////  Created by Cody Hatfield on 2023-10-27.
////
//
//import SwiftUI
//import RealityKit
//import GLTFKit2
//
//struct ModelAugmentPreview: View {
//    @State var assetEntity: Entity? = nil
//    
//    var body: some View {
//        AugmentPreviewView(inputComponents: [[Transform.self]]) { context in
//            guard let entity = context.scene.findEntity(named: "0") else { return }
//            guard let assetEntity = assetEntity else { return }
//            
//            if entity.children.isEmpty {
//                entity.addChild(assetEntity)
//            }
//        }
//        .task {
//            let asset = try? GLTFAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "buddha", ofType: "glb")!))
//            guard let assetScene = asset?.defaultScene else { return }
//            
//            self.assetEntity = GLTFRealityKitLoader.convert(scene: assetScene)
//        }
//    }
//}
//
//#Preview {
//    ModelAugmentPreview()
//}

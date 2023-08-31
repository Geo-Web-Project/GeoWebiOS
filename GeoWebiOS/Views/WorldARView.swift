//
//  ARView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-30.
//

import SwiftUI
import SwiftData
import RealityKit

struct WorldARView: View {
    var worldAddress: String
    
    private var isAnchorPredicate: Predicate<IsAnchorComponent> {
        #Predicate<IsAnchorComponent> { obj in
            obj.worldAddress == worldAddress && obj.value == true
        }
    }

    private var model3DPredicate: Predicate<Model3DComponent> {
        #Predicate<Model3DComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    private var positionPredicate: Predicate<PositionComponent> {
        #Predicate<PositionComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    private var anchorPredicate: Predicate<AnchorComponent> {
        #Predicate<AnchorComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    @Query private var isAnchorComponents: [IsAnchorComponent]
    @Query private var modelComponents: [Model3DComponent]
    @Query private var positionComponents: [PositionComponent]
    @Query private var anchorComponents: [AnchorComponent]

    init(worldAddress: String) {
        self.worldAddress = worldAddress
        
        _isAnchorComponents = Query(filter: isAnchorPredicate)
        _modelComponents = Query(filter: model3DPredicate)
        _positionComponents = Query(filter: positionPredicate)
        _anchorComponents = Query(filter: anchorPredicate)
    }
    
    var body: some View {
        ARViewRepresentable(
            isAnchorComponents: isAnchorComponents,
            modelComponents: modelComponents,
            positionComponents: positionComponents,
            anchorComponents: anchorComponents
        )
        .ignoresSafeArea()
    }
}


struct ARViewRepresentable: UIViewRepresentable {
    let isAnchorComponents: [IsAnchorComponent]
    let modelComponents: [Model3DComponent]
    let positionComponents: [PositionComponent]
    let anchorComponents: [AnchorComponent]
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        for isAnchorComponent in isAnchorComponents {
//            // Create a cube model
//            let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//            let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//            let model = ModelEntity(mesh: mesh, materials: [material])
//            
//            let transform = Transform(translation: SIMD3(x: position.x, y: position.y, z: position.z))
//            
//            model.components.set(transform)
//            
//            mainAnchorEntity.children.append(model)
            let anchorEntity = AnchorEntity()
            anchorEntity.name = isAnchorComponent.key.toHexString()
            arView.scene.anchors.append(anchorEntity)
        }
        
        return arView
        
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        for isAnchorComponent in isAnchorComponents {
            let existingEntity = arView.scene.findEntity(named: isAnchorComponent.key.toHexString())
            if existingEntity == nil {
                let anchorEntity = AnchorEntity()
                anchorEntity.name = isAnchorComponent.key.toHexString()
                arView.scene.anchors.append(anchorEntity)
            }
        }
    }
}

//class ARViewCoordinator: QLPreviewControllerDataSource {
//    let parent: ModelQLView
//    
//    init(parent: ModelQLView) {
//        self.parent = parent
//    }
//    
//    func numberOfPreviewItems(
//        in controller: QLPreviewController
//    ) -> Int {
//        return 1
//    }
//    
//    func previewController(
//        _ controller: QLPreviewController,
//        previewItemAt index: Int
//    ) -> QLPreviewItem {
//        return parent.qlPreviewItem
//    }
//    
//}

#Preview {
    WorldARView(worldAddress: "")
}

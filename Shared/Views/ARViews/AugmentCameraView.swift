//
//  AugmentCameraView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import SwiftUI
import RealityKit
import ARKit

struct AugmentCameraViewRepresentable: UIViewRepresentable {
    let arView: ARView
    let inputComponents: [[Component.Type]]

    func makeUIView(context: Context) -> ARView {
        AugmentInputComponent.registerComponent()
        ImageCom.registerComponent()
        ModelCom.registerComponent()
        NFTCom.registerComponent()
        PositionCom.registerComponent()
        
        AugmentInputSystem.registerSystem()
        FramedImageSystem.registerSystem()
        FramedNFTImageSystem.registerSystem()
        GLBModelSystem.registerSystem()
        
        arView.automaticallyConfigureSession = false
        arView.session.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
                
        // Default anchor
        let anchor = AnchorEntity(world: simd_float3(x: 0, y: 0, z: 0))

        for (i, inputTypes) in inputComponents.enumerated() {
            let entity = Entity()
            entity.name = "\(i+1)"
            entity.components.set(
                AugmentInputComponent(inputTypes: inputTypes)
            )
            anchor.addChild(entity)
        }

        arView.scene.addAnchor(anchor)
                              
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {}
    
    func makeCoordinator() -> AugmentCameraViewCoordinator {
        AugmentCameraViewCoordinator(self)
    }
}

class AugmentCameraViewCoordinator: NSObject, ARSessionDelegate {
    let parent: AugmentCameraViewRepresentable
    
    init(_ parent: AugmentCameraViewRepresentable) {
        self.parent = parent
    }
}

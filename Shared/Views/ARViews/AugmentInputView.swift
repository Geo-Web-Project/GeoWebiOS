//
//  AugmentInputView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import SwiftUI
import RealityKit
import ARKit

struct AugmentInputViewRepresentable: UIViewRepresentable {
    let arView: ARView
    let inputComponents: [[Component.Type]]

    func makeUIView(context: Context) -> ARView {
        AugmentInputComponent.registerComponent()
        ImageCom.registerComponent()
        ModelCom.registerComponent()
        
        AugmentInputSystem.registerSystem()
        FramedImageSystem.registerSystem()
        GLBModelSystem.registerSystem()
        
        arView.automaticallyConfigureSession = false
        arView.session.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
                
        // Default anchor
        let anchor = AnchorEntity(world: simd_float3(x: 0, y: 0, z: 0))

        for (i, inputTypes) in inputComponents.enumerated() {
            let entity = Entity()
            entity.name = "\(i)"
            entity.components.set(
                AugmentInputComponent(inputTypes: inputTypes)
            )
            anchor.addChild(entity)
        }

        arView.scene.addAnchor(anchor)
                              
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {}
    
    func makeCoordinator() -> AugmentInputViewCoordinator {
        AugmentInputViewCoordinator(self)
    }
}

class AugmentInputViewCoordinator: NSObject, ARSessionDelegate {
    let parent: AugmentInputViewRepresentable
    
    init(_ parent: AugmentInputViewRepresentable) {
        self.parent = parent
    }
}

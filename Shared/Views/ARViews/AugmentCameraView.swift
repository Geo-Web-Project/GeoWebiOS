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
//    @Binding var overlayText: String

    func makeUIView(context: Context) -> ARView {
        AugmentInputComponent.registerComponent()
        ImageCom.registerComponent()
        ModelCom.registerComponent()
//        NFTCom.registerComponent()
        PositionCom.registerComponent()
        
        AugmentInputSystem.registerSystem()
////        FramedImageSystem.registerSystem()
////        FramedNFTImageSystem.registerSystem()
//        GLBModelSystem.registerSystem()
        USDZModelSystem.registerSystem()
        GeoAnchorSystem.registerSystem()
        
        arView.automaticallyConfigureSession = false
        arView.session.delegate = context.coordinator
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        
        let configuration = ARGeoTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics.insert(.sceneDepth)
        }
//        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
//            configuration.sceneReconstruction = .mesh
//        }
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

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let geoAnchor = anchor as? ARGeoAnchor else { continue }
            guard let name = geoAnchor.name else { continue }
            
            guard let anchorEntity = self.parent.arView.scene.findEntity(named: name) as? AnchorEntity else { return }
            guard let positionCom = anchorEntity.components[PositionCom.self] as? PositionCom else { return }
            positionCom.geoAnchor = geoAnchor
        }
    }
}

struct CoachingOverlayView: UIViewRepresentable {
    let arView: ARView
    
    func makeUIView(context: Context) -> ARCoachingOverlayView {
        let coachingOverlayView = ARCoachingOverlayView()
        coachingOverlayView.session = arView.session
        coachingOverlayView.goal = .geoTracking
                              
        return coachingOverlayView
    }
    
    func updateUIView(_ view: ARCoachingOverlayView, context: Context) {}
}


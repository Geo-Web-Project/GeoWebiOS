//
//  AugmentCameraView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import SwiftUI
import RealityKit
import ARKit
import Geohash

struct AugmentCameraViewRepresentable: UIViewRepresentable {
    let arView: ARView
    let inputComponents: [[Component.Type]]
    let positionComs: [PositionCom]
    let orientationComs: [OrientationCom]
    let scaleComs: [ScaleCom]
    let modelComs: [ModelCom]
    let imageComs: [ImageCom]
    
    init(arView: ARView, inputComponents: [[Component.Type]], positionComs: [PositionCom], orientationComs: [OrientationCom], scaleComs: [ScaleCom], modelComs: [ModelCom], imageComs: [ImageCom]) {
        self.arView = arView
        self.inputComponents = inputComponents
        self.positionComs = positionComs
        self.orientationComs = orientationComs
        self.scaleComs = scaleComs
        self.modelComs = modelComs
        self.imageComs = imageComs
    }
    
    init(arView: ARView, inputComponents: [[Component.Type]]) {
        self.arView = arView
        self.inputComponents = inputComponents
        self.positionComs = []
        self.orientationComs = []
        self.scaleComs = []
        self.modelComs = []
        self.imageComs = []
    }
    
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
        anchor.name = "default"

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
    
    func updateUIView(_ arView: ARView, context: Context) {
        for com in positionComs {
            if let entity = arView.scene.findEntity(named: com.key.toHexString()) as? AnchorEntity {
                if let positionCom = entity.components[PositionCom.self] as? PositionCom {
                    if com.geohash != positionCom.geohash {
                        // If geohash changed, remove and add geo anchor
                        if let geoAnchor = positionCom.geoAnchor {
                            arView.session.remove(anchor: geoAnchor)
                        }
                        
                        
                        if let geohash = com.geohash {
                            let geoAnchor = ARGeoAnchor(
                                name: entity.name,
                                coordinate: CLLocationCoordinate2D(geohash: geohash)
                            )
                            com.geoAnchor = geoAnchor
                            arView.session.add(anchor: geoAnchor)
                        }
                    }
                }
                
                entity.components.set(com)
            } else {
                let entity = AnchorEntity(world: simd_float3(x: 0, y: 0, z: 0))
                
                entity.name = com.key.toHexString()
                entity.components.set(com)
                entity.isEnabled = false
                arView.scene.addAnchor(entity)
                
                if let geohash = com.geohash {
                    let geoAnchor = ARGeoAnchor(
                        name: entity.name,
                        coordinate: CLLocationCoordinate2D(geohash: geohash)
                    )
                    com.geoAnchor = geoAnchor
                    arView.session.add(anchor: geoAnchor)
                }
            }
        }
        
        for com in modelComs {
            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
            entity.components.set(com)
        }
        
        for com in orientationComs {
            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
            entity.components.set(com)
        }
        
        for com in scaleComs {
            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
            entity.components.set(com)
        }
    
        for com in imageComs {
            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
            entity.components.set(com)
        }
        
        // Remove missing entities
        let entityIds = Set(positionComs.map { $0.key.toHexString() } + modelComs.map { $0.key.toHexString() })
        for anchor in arView.scene.anchors {
            guard anchor.name != "default" else { continue }
            
            if !entityIds.contains(anchor.name) {
                arView.scene.removeAnchor(anchor)
            }
        }
    }
    
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


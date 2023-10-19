//
//  ImageTargetARView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-09-15.
//

import SwiftUI
import RealityKit
import ARKit
import Spatial

struct ImageTargetARView: View {
    private let arView: ARView = ARView(frame: .zero)
    @State private var overlayText: String = ""
    @State private var triggerPlaceObject: Bool = false

    var body: some View {
        ZStack {
            ARViewRepresentable(overlayText: $overlayText, triggerPlaceObject: $triggerPlaceObject, arView: arView)
                .ignoresSafeArea()
        
            CoachingOverlayView(arView: arView)
            
            VStack {
                Spacer()
                Text(overlayText)
            }
        }
    }
}

private struct ARViewRepresentable: UIViewRepresentable {
    @Binding var overlayText: String
    @Binding var triggerPlaceObject: Bool
    
    let arView: ARView
    
    init(overlayText: Binding<String>, triggerPlaceObject: Binding<Bool>, arView: ARView) {
        self._overlayText = overlayText
        self._triggerPlaceObject = triggerPlaceObject
        self.arView = arView
    }
    
    func makeUIView(context: Context) -> ARView {
        arView.automaticallyConfigureSession = false
        arView.session.delegate = context.coordinator
        
        PlaneTestSystem.registerSystem()
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "ar-images", bundle: nil)
        
        let entity = AnchorEntity()
        entity.name = "default"
        arView.scene.addAnchor(entity)
        
//        let imageAnchor = Entity()
//        imageAnchor.name = "wall"
//        entity.addChild(imageAnchor)
        
//        let planeAnchor = Entity()
//        planeAnchor.name = "plane"
//        entity.addChild(planeAnchor)
        
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.1))
        box.name = "box"
        box.isEnabled = false
        entity.addChild(box)
                
        arView.session.run(configuration)
                
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
//        if triggerPlaceObject {
//            context.coordinator.placeObject()
//        }
    }
    
    func makeCoordinator() -> ARViewCoordinator {
        ARViewCoordinator(self)
    }
}

private class ARViewCoordinator: NSObject, ARSessionDelegate {
    let parent: ARViewRepresentable
    var nextObject: Entity
    
    init(_ parent: ARViewRepresentable) {
        self.parent = parent
        self.nextObject = ModelEntity(mesh: MeshResource.generateBox(size: 0.1))
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.classification == .floor, planeAnchor.alignment == .horizontal {
                let entity = AnchorEntity(.world(transform: anchor.transform))
                entity.name = "plane"
                parent.arView.scene.addAnchor(entity)
                parent.overlayText += "\nPlane Found"
                continue
            }
            
            guard let name = anchor.name else { continue }
            parent.overlayText += "\n\(name) anchor found"

            if let entity = parent.arView.scene.findEntity(named: name) as? AnchorEntity {
                entity.anchor?.reanchor(.world(transform: anchor.transform), preservingWorldTransform: false)
            } else {
                let entity = AnchorEntity(.world(transform: anchor.transform))
                entity.name = name
                parent.arView.scene.addAnchor(entity)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.classification == .floor, planeAnchor.alignment == .horizontal {
                let entity = AnchorEntity(.world(transform: anchor.transform))
                entity.name = "plane"
                parent.arView.scene.addAnchor(entity)
                continue
            }
            
            guard let name = anchor.name else { continue }
            if let entity = parent.arView.scene.findEntity(named: name) as? AnchorEntity {
                entity.anchor?.reanchor(.world(transform: anchor.transform), preservingWorldTransform: false)
            } else {
                let entity = AnchorEntity(.world(transform: anchor.transform))
                entity.name = name
                parent.arView.scene.addAnchor(entity)
            }
        }
    }
    
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        if let geoTrackingStatus = frame.geoTrackingStatus {
//            self.parent.overlayText = "\(geoTrackingStatus.accuracy)"
//        }
//        
//        guard let query = parent.arView.makeRaycastQuery(from: parent.arView.center, allowing: .existingPlaneInfinite, alignment: .horizontal) else { return }
//        
//        guard let result = session.raycast(query).first else { return }
//        
//        if let defaultAnchor = self.parent.arView.scene.findEntity(named: "default") {
//            if nextObject.parent == nil {
//                defaultAnchor.addChild(nextObject)
//            }
//            nextObject.transform.matrix = result.worldTransform
//        }
//    }
    
//    func placeObject() {
//        nextObject = ModelEntity(mesh: MeshResource.generateBox(size: 0.1))
//        Task.detached {
//            self.parent.triggerPlaceObject = false
//        }
//    }
}

private struct CoachingOverlayView: UIViewRepresentable {
    let arView: ARView
    
    func makeUIView(context: Context) -> ARCoachingOverlayView {
        let coachingOverlayView = ARCoachingOverlayView()
        coachingOverlayView.session = arView.session
        coachingOverlayView.goal = .horizontalPlane
                              
        return coachingOverlayView
    }
    
    func updateUIView(_ view: ARCoachingOverlayView, context: Context) {}
}

class PlaneTestSystem : System {
    private static let query = EntityQuery(where: .has(ModelComponent.self))

    required init(scene: RealityKit.Scene) { }
    
    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard entity.name == "box" else { return }
            guard let imageEntity = context.scene.findEntity(named: "wall") else { return }
            guard let planeEntity = context.scene.findEntity(named: "plane") else { return }
                        
            let startTranslation = SIMD3<Float>(x: 0, y: 0.0, z: 1.0)
//            let startOrientation = simd_quatf(vector: simd_float4(x: 0.0, y: 0.0, z: 0.0, w: 1.0))
                        
            let newTranslation = SIMD3<Float>(
                imageEntity.anchor?.anchoring.target.translation?.x ?? 0.0,
                planeEntity.anchor?.anchoring.target.translation?.y ?? 0.0,
                imageEntity.anchor?.anchoring.target.translation?.z ?? 0.0
            )
            
            print(newTranslation)
                        
//            let newRotation = simd_quatf(vector: simd_float4(
//                x: imageEntity.anchor?.anchoring.target.orientation?.vector.x ?? 0.0,
//                y: imageEntity.anchor?.anchoring.target.orientation?.vector.y ?? 0.0,
//                z: imageEntity.anchor?.anchoring.target.orientation?.vector.z ?? 0.0,
//                w: imageEntity.anchor?.anchoring.target.orientation?.vector.w ?? 1.0
//            ))
//                                    
//            let finalRotation = simd_mul(newRotation, startOrientation)
//            
//            entity.transform.rotation = simd_quatf(vector: simd_float4(x: finalRotation.vector.x, y: 0.0, z: 0.0, w: 1.0))
            entity.transform.translation = newTranslation + simd_act(entity.transform.rotation, startTranslation)
//            entity.transform.rotation = simd_mul(newRotation, simd_quatf(vector: simd_float4(x: 0.0, y: 0.0, z: 0.0, w: 1.0)))
//            entity.transform.translation = newTranslation + simd_act(entity.transform.rotation, SIMD3<Float>(x: 0, y: 0, z: 0))
            entity.isEnabled = true
        }
    }
}

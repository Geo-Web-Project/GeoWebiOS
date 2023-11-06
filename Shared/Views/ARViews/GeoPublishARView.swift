//
//  GeoPublishARView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-09-15.
//

import SwiftUI
import RealityKit
import ARKit

struct GeoPublishARView: View {
    private let arView: ARView = ARView(frame: .zero)
    @State private var overlayText: String = ""
    @State private var triggerPlaceObject: Bool = false

    var body: some View {
        if ARGeoTrackingConfiguration.isSupported {
            ZStack {
                ARViewRepresentable(overlayText: $overlayText, triggerPlaceObject: $triggerPlaceObject, arView: arView)
                    .ignoresSafeArea()
                    .onAppear {
                        ARGeoTrackingConfiguration.checkAvailability { isAvailable, error in
                            if error != nil || !isAvailable {
                                overlayText = "Geo tracking not available at this location"
                            }
                        }
                    }
            
                CoachingOverlayView(arView: arView)
                
                VStack {
                    Spacer()
                    Text(overlayText)
                    Button(action: {
                        triggerPlaceObject.toggle()
                    }, label: {
                        Text("Place Object")
                    })
                    .buttonStyle(.bordered)
                    .background(.ultraThickMaterial)
                    .padding(.bottom)
                }
            }
        } else {
            Text("Geo tracking not supported by device")
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
        
        let configuration = ARGeoTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        let entity = AnchorEntity()
        entity.name = "default"
        arView.scene.addAnchor(entity)
        
        arView.session.run(configuration)
                
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        if triggerPlaceObject {
            context.coordinator.placeObject()
        }
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
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let geoTrackingStatus = frame.geoTrackingStatus {
            self.parent.overlayText = "\(geoTrackingStatus.accuracy)"
        }
        
        guard let query = parent.arView.makeRaycastQuery(from: parent.arView.center, allowing: .existingPlaneInfinite, alignment: .horizontal) else { return }
        
        guard let result = session.raycast(query).first else { return }
        
        if let defaultAnchor = self.parent.arView.scene.findEntity(named: "default") {
            if nextObject.parent == nil {
                defaultAnchor.addChild(nextObject)
            }
            nextObject.transform.matrix = result.worldTransform
        }
    }
    
    func placeObject() {
        nextObject = ModelEntity(mesh: MeshResource.generateBox(size: 0.1))
        Task.detached {
            self.parent.triggerPlaceObject = false
        }
    }
}

//private struct CoachingOverlayView: UIViewRepresentable {
//    let arView: ARView
//    
//    func makeUIView(context: Context) -> ARCoachingOverlayView {
//        let coachingOverlayView = ARCoachingOverlayView()
//        coachingOverlayView.session = arView.session
//        coachingOverlayView.goal = .geoTracking
//                              
//        return coachingOverlayView
//    }
//    
//    func updateUIView(_ view: ARCoachingOverlayView, context: Context) {}
//}

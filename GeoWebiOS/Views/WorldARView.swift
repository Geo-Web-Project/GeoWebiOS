//
//  ARView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-30.
//

import SwiftUI
import SwiftData
import RealityKit
import ARKit

struct WorldARView: View {
    var worldAddress: String

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
    
    private var scalePredicate: Predicate<ScaleComponent> {
        #Predicate<ScaleComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    private var orientationPredicate: Predicate<OrientationComponent> {
        #Predicate<OrientationComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    private var anchorPredicate: Predicate<AnchorComponent> {
        #Predicate<AnchorComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    private var trackedImagePredicate: Predicate<TrackedImageComponent> {
        #Predicate<TrackedImageComponent> { obj in
            obj.worldAddress == worldAddress
        }
    }
    
    @Query private var modelComponents: [Model3DComponent]
    @Query private var positionComponents: [PositionComponent]
    @Query private var scaleComponents: [ScaleComponent]
    @Query private var orientationComponents: [OrientationComponent]
    @Query private var anchorComponents: [AnchorComponent]
    @Query private var trackedImageComponents: [TrackedImageComponent]
    @State private var modelRealityComponents: [String: ModelComponent] = [:]
    @State private var trackedReferenceImages: [String: ARReferenceImage] = [:]
    @State private var isReady: Bool = false
    
    init(worldAddress: String) {
        self.worldAddress = worldAddress
        
        _modelComponents = Query(filter: model3DPredicate)
        _positionComponents = Query(filter: positionPredicate)
        _scaleComponents = Query(filter: scalePredicate)
        _orientationComponents = Query(filter: orientationPredicate)
        _anchorComponents = Query(filter: anchorPredicate)
        _trackedImageComponents = Query(filter: trackedImagePredicate)
    }
    
    var body: some View {
        if !isReady {
            VStack {
                Text("Loading objects...")
                ProgressView()
            }
                .task {
                    AnchorTransformComponent.registerComponent()
                    AnchorTransformSystem.registerSystem()
                    
                    await withTaskGroup(of: (String, ARReferenceImage?).self) { taskGroup in
                        for trackedImageComponent in trackedImageComponents {
                            taskGroup.addTask {
                                let key = trackedImageComponent.key.toHexString()

                                do {
                                    guard let url = trackedImageComponent.imageAssetUrl else { return (key, nil) }
                                    
                                    if url.isFileURL {
                                        // Load local file
                                        guard let image = UIImage(contentsOfFile: url.path())?.cgImage else { return (key, nil) }
                                
                                        let referenceImage = ARReferenceImage(image, orientation: .up, physicalWidth: CGFloat(Float(trackedImageComponent.imageWidthInMillimeters)) / 1000)
                                        referenceImage.name = key
                                        
                                        return (key, referenceImage)
                                    } else {
                                        // Load remote URL
                                        let (url, response) = try await URLSession.shared.download(for: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
                                        
                                        if let suggestedFilename = response.suggestedFilename {
                                            let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
                                            
                                            // Rename with suggested name
                                            if !FileManager.default.fileExists(atURL: newUrl) {
                                                try FileManager.default.moveItem(at: url, to: newUrl)
                                            }
                                            
                                            guard let image = UIImage(contentsOfFile: newUrl.path())?.cgImage else { return (key, nil) }
                                    
                                            let referenceImage = ARReferenceImage(image, orientation: .up, physicalWidth: CGFloat(Float(trackedImageComponent.imageWidthInMillimeters)) / 1000)
                                            referenceImage.name = key

                                            return (key, referenceImage)
                                        } else {
                                            guard let image = UIImage(contentsOfFile: url.path())?.cgImage else { return (key, nil) }
                                    
                                            let referenceImage = ARReferenceImage(image, orientation: .up, physicalWidth: CGFloat(Float(trackedImageComponent.imageWidthInMillimeters)) / 1000)
                                            referenceImage.name = key

                                            return (key, referenceImage)
                                        }
                                    }
                                } catch {
                                    print("Failed to load tracked image component: \(error)")
                                    return (key, nil)
                                }
                            }
                        }
                        
                        for await result in taskGroup {
                            trackedReferenceImages[result.0] = result.1
                        }
                    }
                    
                    await withTaskGroup(of: (String, ModelComponent?).self) { taskGroup in
                        for modelComponent in modelComponents {
                            taskGroup.addTask {
                                let key = modelComponent.key.toHexString()

                                do {
                                    guard let usdzUrl = modelComponent.usdzUrl else { return (key, nil) }
                                    
                                    if usdzUrl.isFileURL {
                                        // Load local file
                                        let modelEntity = try await Entity.loadModel(contentsOf: usdzUrl)
                                        guard let model = await modelEntity.model else { return (key, nil) }
                                        
                                        return (key, model)
                                    } else {
                                        // Load remote URL
                                        let (url, response) = try await URLSession.shared.download(for: URLRequest(url: usdzUrl, cachePolicy: .returnCacheDataElseLoad))
                                        
                                        if let suggestedFilename = response.suggestedFilename {
                                            let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
                                            
                                            // Rename with suggested name
                                            if !FileManager.default.fileExists(atURL: newUrl) {
                                                try FileManager.default.moveItem(at: url, to: newUrl)
                                            }
                                            
                                            let modelEntity = try await Entity.loadModel(contentsOf: newUrl)
                                            guard let model = await modelEntity.model else { return (key, nil) }
                                            
                                            return (key, model)
                                        } else {
                                            let modelEntity = try await Entity.loadModel(contentsOf: url)
                                            guard let model = await modelEntity.model else { return (key, nil) }
                                            
                                            return (key, model)
                                        }
                                    }
                                } catch {
                                    print("Failed to load model component: \(error)")
                                    return (key, nil)
                                }
                            }
                        }
                        
                        for await result in taskGroup {
                            modelRealityComponents[result.0] = result.1
                        }
                    }
                    
                    isReady = true
                }
        } else {
            ARViewRepresentable(
                arComponents: anchorComponents + positionComponents + scaleComponents + orientationComponents,
                modelComponents: modelComponents,
                trackedImageComponents: trackedImageComponents,
                modelRealityComponents: modelRealityComponents,
                trackedReferenceImages: trackedReferenceImages
            )
            .ignoresSafeArea()
        }
    }
}


struct ARViewRepresentable: UIViewRepresentable {
    var arView = ARView(frame: .zero)
    
    let arComponents: [ARComponent]
    let modelComponents: [Model3DComponent]
    let trackedImageComponents: [TrackedImageComponent]
    let modelRealityComponents: [String: ModelComponent]
    let trackedReferenceImages: [String: ARReferenceImage]
    
    func makeUIView(context: Context) -> ARView {
        arView.automaticallyConfigureSession = false
        arView.session.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = Set(trackedReferenceImages.values)
        
        let entity = AnchorEntity()
        entity.name = "default"
        
        arView.scene.addAnchor(entity)
        
        arView.session.run(configuration)
                              
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        for arComponent in arComponents {
            arComponent.updateARView(arView)
        }

        for modelComponent in modelComponents {
            let key = modelComponent.key.toHexString()
            guard let model = modelRealityComponents[key] else { continue }
            
            let entity = arView.scene.findEntity(named: key) ?? Entity()
            entity.name = key
            entity.components.set(model)
        }
    }
    
    func makeCoordinator() -> ARViewCoordinator {
        ARViewCoordinator(self)
    }
}

class ARViewCoordinator: NSObject, ARSessionDelegate {
    let parent: ARViewRepresentable
    
    init(_ parent: ARViewRepresentable) {
        self.parent = parent
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
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
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
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
}

#Preview {
    WorldARView(worldAddress: "")
}

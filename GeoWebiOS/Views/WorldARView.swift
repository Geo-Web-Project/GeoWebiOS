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
import GLTFKit2

struct WorldARView: View {
    var worldAddress: String

    private var model3DPredicate: Predicate<ModelComponent> {
        #Predicate<ModelComponent> { obj in
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
    
    @Query private var modelComponents: [ModelComponent]
    @Query private var positionComponents: [PositionComponent]
    @Query private var scaleComponents: [ScaleComponent]
    @Query private var orientationComponents: [OrientationComponent]
    @Query private var anchorComponents: [AnchorComponent]
    @Query private var trackedImageComponents: [TrackedImageComponent]
    @State private var modelRealityComponents: [String: Entity] = [:]
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
                    
                    trackedReferenceImages = await withTaskGroup(of: (String, ARReferenceImage?).self, returning: [String : ARReferenceImage].self) { taskGroup in
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
                                            if !FileManager.default.fileExists(atPath: newUrl.path()) {
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
                        
                        return await taskGroup.reduce(into: [:]) { prev, cur in
                            if cur.1 != nil {
                                prev[cur.0] = cur.1
                            }
                        }
                    }
                                        
                    modelRealityComponents = await withTaskGroup(of: (String, Entity?).self, returning: [String : Entity].self) { taskGroup in
                        for modelComponent in modelComponents {
                            taskGroup.addTask {
                                let key = modelComponent.key.toHexString()

                                do {
                                    guard let contentHashUrl = modelComponent.contentHashUrl else { return (key, nil) }
                                    
                                    if contentHashUrl.isFileURL {
                                        // Load local file
                                        switch modelComponent.encodingFormat {
                                        case .Glb:
                                            let asset = try GLTFAsset(url: contentHashUrl)
                                            guard let scene = asset.defaultScene else { return (key, nil) }
                                            let entity = await MainActor.run {
                                                GLTFRealityKitLoader.convert(scene: scene)
                                            }
                                            
                                            return (key, entity)
                                        case .Usdz:
                                            let modelEntity = try await Entity.loadModel(contentsOf: contentHashUrl)
                                            return (key, modelEntity)
                                        }
                                    } else {
                                        // Load remote URL
                                        let (url, response) = try await URLSession.shared.download(for: URLRequest(url: contentHashUrl, cachePolicy: .returnCacheDataElseLoad))
                                        
                                        var contentUrl = url
                                        if let suggestedFilename = response.suggestedFilename {
                                            let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
                                            
                                            // Rename with suggested name
                                            if !FileManager.default.fileExists(atPath: newUrl.path()) {
                                                try FileManager.default.moveItem(at: url, to: newUrl)
                                            }
                                            
                                            contentUrl = newUrl
                                        }
                                        
                                        switch modelComponent.encodingFormat {
                                        case .Glb:
                                            let asset = try GLTFAsset(url: contentUrl)
                                            guard let scene = asset.defaultScene else { return (key, nil) }
                                            let entity = await MainActor.run {
                                                GLTFRealityKitLoader.convert(scene: scene)
                                            }
                                            return (key, entity)
                                        case .Usdz:
                                            let modelEntity = try await Entity.loadModel(contentsOf: contentUrl)
//                                            guard let model = await modelEntity.model else { return (key, nil) }
                                            
                                            return (key, modelEntity)
                                        }
                                    }
                                } catch {
                                    print("Failed to load model component: \(error)")
                                    return (key, nil)
                                }
                            }
                        }
                        
                        return await taskGroup.reduce(into: [:]) { prev, cur in
                            if cur.1 != nil {
                                prev[cur.0] = cur.1
                            }
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
    let modelComponents: [ModelComponent]
    let trackedImageComponents: [TrackedImageComponent]
    let modelRealityComponents: [String: Entity]
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
            entity.addChild(model)
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

extension PositionComponent: ARComponent {
    func updateARView(_ arView: ARView) {
        let entity = arView.scene.findEntity(named: key.toHexString()) ?? Entity()
        entity.name = key.toHexString()
        
        var transform = entity.components[StartTransformComponent.self] as? StartTransformComponent ?? StartTransformComponent()
        transform.translation = SIMD3(x: x, y: y, z: z)
        entity.components.set(transform)
    }
}

extension ScaleComponent: ARComponent {
    func updateARView(_ arView: ARView) {
        let entity = arView.scene.findEntity(named: key.toHexString()) ?? Entity()
        entity.name = key.toHexString()

        var transform = entity.components[StartTransformComponent.self] as? StartTransformComponent ?? StartTransformComponent()
        transform.scale = SIMD3(x: x, y: y, z: z)
        entity.components.set(transform)
    }
}

extension OrientationComponent: ARComponent {
    func updateARView(_ arView: ARView) {
        let entity = arView.scene.findEntity(named: key.toHexString()) ?? Entity()
        entity.name = key.toHexString()
        
        var transform = entity.components[StartTransformComponent.self] as? StartTransformComponent ?? StartTransformComponent()
        transform.orientation = simd_quatf(ix: x, iy: y, iz: z, r: w)
        entity.components.set(transform)
    }
}

extension AnchorComponent: ARComponent {
    func updateARView(_ arView: ARView) {
        let entity = arView.scene.findEntity(named: key.toHexString()) ?? Entity()
        entity.name = key.toHexString()
        
        entity.components.set(AnchorTransformComponent(
            anchor: anchor.toHexString()
        ))
        entity.isEnabled = false
        
        let anchorEntity = arView.scene.findEntity(named: "default")
        anchorEntity?.addChild(entity)
    }
}

#Preview {
    WorldARView(worldAddress: "")
}

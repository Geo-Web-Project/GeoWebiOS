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
    
    @Query private var isAnchorComponents: [IsAnchorComponent]
    @Query private var modelComponents: [Model3DComponent]
    @Query private var positionComponents: [PositionComponent]
    @Query private var scaleComponents: [ScaleComponent]
    @Query private var orientationComponents: [OrientationComponent]
    @Query private var anchorComponents: [AnchorComponent]
    @State private var modelRealityComponents: [String: ModelComponent] = [:]
    @State private var isReady: Bool = false
    
    init(worldAddress: String) {
        self.worldAddress = worldAddress
        
        _isAnchorComponents = Query(filter: isAnchorPredicate)
        _modelComponents = Query(filter: model3DPredicate)
        _positionComponents = Query(filter: positionPredicate)
        _scaleComponents = Query(filter: scalePredicate)
        _orientationComponents = Query(filter: orientationPredicate)
        _anchorComponents = Query(filter: anchorPredicate)
    }
    
    var body: some View {
        if !isReady {
            VStack {
                Text("Loading objects...")
                ProgressView()
            }
                .task {
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
                isAnchorComponents: isAnchorComponents,
                modelComponents: modelComponents,
                positionComponents: positionComponents,
                scaleComponents: scaleComponents,
                orientationComponents: orientationComponents,
                anchorComponents: anchorComponents,
                modelRealityComponents: modelRealityComponents
            )
            .ignoresSafeArea()
        }
    }
}


struct ARViewRepresentable: UIViewRepresentable {
    let isAnchorComponents: [IsAnchorComponent]
    let modelComponents: [Model3DComponent]
    let positionComponents: [PositionComponent]
    let scaleComponents: [ScaleComponent]
    let orientationComponents: [OrientationComponent]
    let anchorComponents: [AnchorComponent]
    let modelRealityComponents: [String: ModelComponent]
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
      
        updateUIView(arView, context: context)
                
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        for isAnchorComponent in isAnchorComponents {
            let entity = arView.scene.findEntity(named: isAnchorComponent.key.toHexString()) as? AnchorEntity ?? AnchorEntity()
            entity.name = isAnchorComponent.key.toHexString()
            
            arView.scene.anchors.append(entity)
        }
        
        for anchorComponent in anchorComponents {
            let entity = arView.scene.findEntity(named: anchorComponent.key.toHexString()) ?? Entity()
            entity.name = anchorComponent.key.toHexString()
        
            let anchorEntity = arView.scene.findEntity(named: anchorComponent.anchor.toHexString())
            anchorEntity?.addChild(entity)
        }
        
        for positionComponent in positionComponents {
            let entity = arView.scene.findEntity(named: positionComponent.key.toHexString()) ?? Entity()
            entity.name = positionComponent.key.toHexString()
            
            var transform = entity.components.has(Transform.self) ? entity.transform : Transform()
            transform.translation = SIMD3(x: positionComponent.x, y: positionComponent.y, z: positionComponent.z)
            entity.components.set(transform)
        }
        
        for scaleComponent in scaleComponents {
            let entity = arView.scene.findEntity(named: scaleComponent.key.toHexString()) ?? Entity()
            entity.name = scaleComponent.key.toHexString()
            
            var transform = entity.components.has(Transform.self) ? entity.transform : Transform()
            transform.scale = SIMD3(x: scaleComponent.x, y: scaleComponent.y, z: scaleComponent.z)
            entity.components.set(transform)
        }
        
        for orientationComponent in orientationComponents {
            let entity = arView.scene.findEntity(named: orientationComponent.key.toHexString()) ?? Entity()
            entity.name = orientationComponent.key.toHexString()
            
            var transform = entity.components.has(Transform.self) ? entity.transform : Transform()
            transform.rotation = simd_quatf(ix: orientationComponent.x, iy: orientationComponent.y, iz: orientationComponent.z, r: orientationComponent.w)
            entity.components.set(transform)
        }
        
        for modelComponent in modelComponents {
            let key = modelComponent.key.toHexString()
            guard let model = modelRealityComponents[key] else { continue }
            
            let entity = arView.scene.findEntity(named: modelComponent.key.toHexString()) ?? Entity()
            entity.name = key
            entity.components.set(model)
        }
    }
}

#Preview {
    WorldARView(worldAddress: "")
}

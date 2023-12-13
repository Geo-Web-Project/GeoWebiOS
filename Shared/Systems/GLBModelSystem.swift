//
//  GLBModelSystem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import RealityKit
import GLTFKit2

/*
 * GLBModelSystem
 * - Loads a GLB into a ModelComponent
 */
class GLBModelSystem : System {
    private static let query = EntityQuery(where: .has(ModelCom.self))
    private var hasStartedLoading: Set<String> = Set()
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard let modelCom = entity.components[ModelCom.self] as? ModelCom else { return }
            guard modelCom.encodingFormat == .Glb else { return }

            guard !hasStartedLoading.contains(modelCom.uniqueKey) else { return }
            guard let contentUrl = modelCom.contentUrl else { return }
            
            hasStartedLoading.insert(modelCom.uniqueKey)
            
            if contentUrl.isFileURL {
                do {
                    try addAssetToScene(contentUrl: contentUrl, entity: entity)
                } catch {
                    print(error)
                }
            } else {
                // Download in detached task to not block parent actor
                Task.detached {
                    let (url, response) =  try await URLSession.shared.download(from: contentUrl)
                    var tmpUrl = url
                    if let suggestedFilename = response.suggestedFilename {
                        let newUrl = url.deletingLastPathComponent().appending(path: suggestedFilename)
                        
                        // Rename with suggested name
                        try? FileManager.default.moveItem(at: url, to: newUrl)
                        
                        tmpUrl = newUrl
                    }
                    
                    // Add asset back on main actor
                    try await self.addAssetToScene(contentUrl: tmpUrl, entity: entity)
                }
            }
        }
    }
    
    @MainActor
    private func addAssetToScene(contentUrl: URL, entity: Entity) throws {
        let asset = try GLTFAsset(url: contentUrl)
        guard let assetScene = asset.defaultScene else { return }
                
        // TODO: It seems part of this needs to be done on the main actor. But it blocks RealityKit. Is there some other long-running task in here that doesn't need to be on the main actor?
        let gltfEntity = GLTFRealityKitLoader.convert(scene: assetScene)
        entity.addChild(gltfEntity)
    }
}

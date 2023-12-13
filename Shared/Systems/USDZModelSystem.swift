//
//  USDZModelSystem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-10.
//

import RealityKit
import GLTFKit2

/*
 * USDZModelSystem
 * - Loads a USDZ into a ModelComponent
 */
class USDZModelSystem : System {
    private static let query = EntityQuery(where: .has(ModelCom.self))
    private var hasStartedLoading: Set<String> = Set()
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard entity.isEnabled else { return }
            guard let modelCom = entity.components[ModelCom.self] as? ModelCom else { return }
            guard modelCom.encodingFormat == .Usdz else { return }
            
            guard !hasStartedLoading.contains(modelCom.uniqueKey) else { return }
            guard let contentUrl = modelCom.contentUrl else { return }
            
            hasStartedLoading.insert(modelCom.uniqueKey)
            
            if contentUrl.isFileURL {
                do {
                    try addAssetToScene(contentUrl: contentUrl, entity: entity)
                    print("Added USDZ asset to entity: \(entity.name)")
                } catch {
                    print("Error adding USDZ asset (\(entity.name)): \(error)")
                }
            } else {
                // Download in detached task to not block parent actor
                Task.detached {
                    do {
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
                        
                        print("Added USDZ asset to entity: \(await entity.name)")
                    } catch {
                        print("Error adding USDZ asset (\(await entity.name)): \(error)")
                    }
                }
            }
        }
    }
    
    @MainActor
    private func addAssetToScene(contentUrl: URL, entity: Entity) throws {
        let usdzEntity = try Entity.load(contentsOf: contentUrl)
        entity.addChild(usdzEntity)
    }
}

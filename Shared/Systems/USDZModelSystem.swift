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
            let contentUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "robot", ofType: "usdz")!)
            
            hasStartedLoading.insert(modelCom.uniqueKey)
            
            if contentUrl.isFileURL {
                do {
                    try addAssetToScene(contentUrl: contentUrl, entity: entity)
                    print("Added USDZ asset to entity: \(entity)")
                } catch {
                    print("Error adding USDZ asset: \(error)")
                }
            } else {
                // Download in detached task to not block parent actor
                Task.detached {
                    let (url, _) =  try await URLSession.shared.download(from: contentUrl)
                    
                    // Add asset back on main actor
                    try await self.addAssetToScene(contentUrl: url, entity: entity)
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

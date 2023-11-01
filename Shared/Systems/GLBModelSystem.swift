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
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard let modelCom = entity.components[ModelCom.self] as? ModelCom else { return }
            guard let contentUrl = modelCom.contentUrl else { return }
            guard entity.children.count == 0 else { return }
            
            let asset = try? GLTFAsset(url: contentUrl)
            guard let assetScene = asset?.defaultScene else { return }

            let gltfEntity = GLTFRealityKitLoader.convert(scene: assetScene)
            entity.addChild(gltfEntity)
        }
    }
}

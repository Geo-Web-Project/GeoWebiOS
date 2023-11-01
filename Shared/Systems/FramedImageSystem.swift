//
//  FramedImageSystem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import RealityKit

/*
 * FramedImageSystem
 * - Renders ImageCom on a frame
 */
class FramedImageSystem : System {
    private static let query = EntityQuery(where: .has(ImageCom.self))
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard let imageCom = entity.components[ImageCom.self] as? ImageCom else { return }
            guard let imageAssetUrl = imageCom.contentUrl else { return }
            
            let texture = try! TextureResource.load(contentsOf: imageAssetUrl)
            var material = PhysicallyBasedMaterial()
            material.baseColor.texture = MaterialParameters.Texture(texture)
            
            let physicalHeightInMillimeters = Float(imageCom.physicalWidthInMillimeters ?? 500) * Float(texture.height) / Float(texture.width)
            let plane = MeshResource.generatePlane(width: Float(imageCom.physicalWidthInMillimeters ?? 500) / 1000, height: physicalHeightInMillimeters / 1000)
            
            entity.components.set(
                ModelComponent(mesh: plane, materials: [material])
            )
        }
    }
}

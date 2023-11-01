//
//  FramedNFTImageSystem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-29.
//

import RealityKit
import Foundation
import VarInt

/*
 * FramedNFTImageSystem
 * - Renders NFTCom on a frame if it is an image
 */
class FramedNFTImageSystem : System {
    private static let query = EntityQuery(where: .has(NFTCom.self))
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in            
            guard let nftCom = entity.components[NFTCom.self] as? NFTCom else { return }
            guard let imageCom = entity.components[ImageCom.self] as? ImageCom else { return }
            
            guard let assetUrl = nftCom.contentUrl else { return }
            
            let texture = try! TextureResource.load(contentsOf: assetUrl)
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

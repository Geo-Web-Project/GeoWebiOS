//
//  GeoAnchorSystem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-11-10.
//

import RealityKit
import GLTFKit2
import ARKit

/*
 * GeoAnchorSystem
 * - Add each entity to the corresponding ARGeoAnchor
 * - Set orientation
 * - TODO: Update position based on multiple anchor types
 */
class GeoAnchorSystem : System {
    private static let query = EntityQuery(where: .has(PositionCom.self))
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard let geoAnchorEntity = context.scene.findEntity(named: "geo-\(entity.name)") else { return }
            let orientationCom = entity.components[OrientationCom.self] as? OrientationCom
            let scaleCom = entity.components[OrientationCom.self] as? ScaleCom

            geoAnchorEntity.addChild(entity)
            entity.isEnabled = true
            
            // TODO: Remove 10x hardcoding
            entity.transform.scale.x = Float(scaleCom?.x ?? 10000) / 1000
            entity.transform.scale.y = Float(scaleCom?.y ?? 10000) / 1000
            entity.transform.scale.z = Float(scaleCom?.z ?? 10000) / 1000
            
            let x = Float(orientationCom?.x ?? 0) / 1000
            let y = Float(orientationCom?.y ?? 0) / 1000
            let z = Float(orientationCom?.z ?? 0) / 1000
            let w = Float(orientationCom?.w ?? 0) / 1000
            entity.transform.rotation = simd_quatf(ix: x, iy: y, iz: z, r: w)
        }
    }
}

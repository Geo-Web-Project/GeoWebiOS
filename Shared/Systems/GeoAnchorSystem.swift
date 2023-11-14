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
 * - TODO: Update position based on multiple anchor types
 */
class GeoAnchorSystem : System {
    private static let query = EntityQuery(where: .has(PositionCom.self))
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard let geoAnchorEntity = context.scene.findEntity(named: "geo-\(entity.name)") else { return }
            geoAnchorEntity.addChild(entity)
            entity.isEnabled = true
        }
    }
}

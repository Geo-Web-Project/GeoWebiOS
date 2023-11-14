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
 * - Add a geo anchor for each Position component
 */
class GeoAnchorSystem : System {
    private static let query = EntityQuery(where: .has(PositionCom.self))
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
//            guard let positionCom = entity.components[PositionCom.self] as? PositionCom else { return }
            
            // Check if anchor does not exist
            guard context.scene.findEntity(named: "geo-\(entity.name)") == nil else { return }
            
            entity.isEnabled = true
        }
    }
}

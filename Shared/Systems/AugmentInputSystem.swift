//
//  AugmentInputSystem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import RealityKit

struct AugmentInputComponent: Component {
    var inputTypes: [Component.Type]
}

class AugmentInputSystem : System {
    private static let query = EntityQuery(where: .has(AugmentInputComponent.self))
    
    required init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard let augmentInput = entity.components[AugmentInputComponent.self] as? AugmentInputComponent else { return }
            
            for inputType in augmentInput.inputTypes {
                if inputType == PositionCom.self {
                    // Fixed position
                    entity.transform.translation = SIMD3(x: 0, y: 0, z: -1)
                    
                    entity.isEnabled = true
                }
            }
        }
    }
}

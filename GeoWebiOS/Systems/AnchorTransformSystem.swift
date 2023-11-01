////
////  AnchorTransformSystem.swift
////  GeoWebiOS
////
////  Created by Cody Hatfield on 2023-09-04.
////
//
//import RealityKit
//import Spatial
//
//struct StartTransformComponent: Component {
//    /// The scaling factor applied to the entity.
//    public var scale: SIMD3<Float>?
//
//    /// The rotation of the entity specified as a unit quaternion.
//    public var orientation: simd_quatf?
//
//    /// The position of the entity along the x, y, and z axes.
//    public var translation: SIMD3<Float>?
//}
//
//struct VectorAnchor {
//    var x: String?
//    var y: String?
//    var z: String?
//}
//
//struct QuaternionAnchor {
//    var x: String?
//    var y: String?
//    var z: String?
//    var w: String?
//}
//
//enum PositionAnchor {
//    case raw(String)
//    case vector(VectorAnchor)
//}
//
//enum OrientationAnchor {
//    case raw(String)
//    case quaternion(QuaternionAnchor)
//}
//
//struct AnchorTransformComponent: Component {
//    var anchor: String?
//    var position: PositionAnchor?
//    var orientation: OrientationAnchor?
//}
//
//class AnchorTransformSystem : System {
//    private static let query = EntityQuery(where: .has(AnchorTransformComponent.self))
//
//    required init(scene: Scene) { }
//    
//    func update(context: SceneUpdateContext) {
//        context.scene.performQuery(Self.query).forEach { entity in
//            guard let anchorTransform = entity.components[AnchorTransformComponent.self] as? AnchorTransformComponent else { return }
//            
//            let startTransform = entity.components[StartTransformComponent.self] as? StartTransformComponent
//            let startTranslation = startTransform?.translation ?? SIMD3<Float>(x: 0, y: 0, z: 0)
//            let startOrientation = startTransform?.orientation ?? simd_quatf(vector: simd_float4(x: 0.0, y: 0.0, z: 0.0, w: 1.0))
//            let startScale = startTransform?.scale ?? SIMD3<Float>(x: 1, y: 1, z: 1)
//
//            var anchorPosition: VectorAnchor?
//            var anchorOrientation: QuaternionAnchor?
//            
//            if let anchor = anchorTransform.anchor {
//                anchorPosition = VectorAnchor(x: anchor, y: anchor, z: anchor)
//                anchorOrientation = QuaternionAnchor(x: anchor, y: anchor, z: anchor, w: anchor)
//            } else {
//                switch anchorTransform.position {
//                case .raw(let anchor):
//                    anchorPosition = VectorAnchor(x: anchor, y: anchor, z: anchor)
//                case .vector(let vectorAnchor):
//                    anchorPosition = vectorAnchor
//                default:
//                    break
//                }
//                
//                switch anchorTransform.orientation {
//                case .raw(let anchor):
//                    anchorOrientation = QuaternionAnchor(x: anchor, y: anchor, z: anchor, w: anchor)
//                case .quaternion(let quaternionAnchor):
//                    anchorOrientation = quaternionAnchor
//                default:
//                    break
//                }
//            }
//            
//            // Add to anchor
//            guard let anchorEntityPosX = context.scene.findEntity(named: anchorPosition?.x ?? "default"), anchorEntityPosX.isEnabled else { return }
//            guard let anchorEntityPosY = context.scene.findEntity(named: anchorPosition?.y ?? "default"), anchorEntityPosY.isEnabled else { return }
//            guard let anchorEntityPosZ = context.scene.findEntity(named: anchorPosition?.z ?? "default"), anchorEntityPosZ.isEnabled else { return }
//            
//            guard let anchorEntityRotX = context.scene.findEntity(named: anchorOrientation?.x ?? "default"), anchorEntityRotX.isEnabled else { return }
//            guard let anchorEntityRotY = context.scene.findEntity(named: anchorOrientation?.y ?? "default"), anchorEntityRotY.isEnabled else { return }
//            guard let anchorEntityRotZ = context.scene.findEntity(named: anchorOrientation?.z ?? "default"), anchorEntityRotZ.isEnabled else { return }
//            guard let anchorEntityRotW = context.scene.findEntity(named: anchorOrientation?.w ?? "default"), anchorEntityRotW.isEnabled else { return }
//                        
//            let newTranslation = SIMD3<Float>(
//                anchorEntityPosX.anchor?.anchoring.target.translation?.x ?? 0.0,
//                anchorEntityPosY.anchor?.anchoring.target.translation?.y ?? 0.0,
//                anchorEntityPosZ.anchor?.anchoring.target.translation?.z ?? 0.0
//            )
//                        
//            let newRotation = simd_quatf(vector: simd_float4(
//                x: anchorEntityRotX.anchor?.anchoring.target.orientation?.vector.x ?? 0.0,
//                y: anchorEntityRotY.anchor?.anchoring.target.orientation?.vector.y ?? 0.0,
//                z: anchorEntityRotZ.anchor?.anchoring.target.orientation?.vector.z ?? 0.0,
//                w: anchorEntityRotW.anchor?.anchoring.target.orientation?.vector.w ?? 1.0
//            ))
//                        
//            entity.transform.rotation = simd_mul(newRotation, startOrientation)
//            entity.transform.translation = newTranslation + simd_act(entity.transform.rotation, startTranslation)
//            entity.transform.scale = startScale
//            
//            entity.isEnabled = true
//        }
//    }
//}
//
//extension float4x4 {
//    var translation: SIMD3<Float> {
//        SIMD3<Float>(self.columns.3.x, self.columns.3.y, self.columns.3.z)
//    }
//    
//    var scale: SIMD3<Float> {
//        SIMD3<Float>(self.columns.0.x, self.columns.1.y, self.columns.2.z)
//    }
//    
//    var orientation: simd_quatf {
//        simd_quatf(self)
//    }
//}
//
//extension AnchoringComponent.Target {
//    var translation: SIMD3<Float>? {
//        switch self {
//        case .world(transform: let transform):
//            return transform.translation
//        default:
//            return nil
//        }
//    }
//    
//    var scale: SIMD3<Float>? {
//        switch self {
//        case .world(transform: let transform):
//            return transform.scale
//        default:
//            return nil
//        }
//    }
//    
//    var orientation: simd_quatf? {
//        switch self {
//        case .world(transform: let transform):
//            return transform.orientation
//        default:
//            return nil
//        }
//    }
//}
//

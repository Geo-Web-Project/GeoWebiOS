//
//  GeoModelAugmentView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-11-05.
//

import SwiftUI
import RealityKit
import GLTFKit2
import VarInt
import Combine
import SwiftData
import ARKit

struct GeoModelAugmentPreview: View {
    @Environment(\.modelContext) private var context: ModelContext

    private let arView: ARView = ARView(frame: .zero)
    private let contentURI: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "geoweb", ofType: "glb")!)

    @State var cancellable: Cancellable? = nil
    
    var body: some View {
        ZStack {
            AugmentCameraViewRepresentable(arView: arView, inputComponents: [[PositionCom.self]])
                .onAppear {
                    cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                        guard let geoAnchorEntity = event.scene.findEntity(named: "geo") else { return }
                        guard let modelComs = try? context.fetch(FetchDescriptor<ModelCom>()), modelComs.isEmpty else { return }
                        
//                        if let entity = event.scene.findEntity(named: "1") {
//                            let modelCom = ModelCom(uniqueKey: "1", lastUpdatedAtBlock: 0, key: Data("0".makeBytes()), contentHash: contentHash, encodingFormat: .Glb)
//                            context.insert(modelCom)
//                            entity.components.set(
//                                modelCom
//                            )
//                            
//                            let anchor1 = ARGeoAnchor(coordinate: CLLocationCoordinate2D(latitude: 51.484854, longitude: -0.107987))
//                            let anchorEntity1 = AnchorEntity(anchor: anchor1)
//                            anchorEntity1.addChild(entity)
//                            
//                            arView.scene.addAnchor(anchorEntity1)
//                        }
//                        
//                        if let entity = event.scene.findEntity(named: "2") {
//                            let modelCom = ModelCom(uniqueKey: "2", lastUpdatedAtBlock: 0, key: Data("0".makeBytes()), contentHash: contentHash, encodingFormat: .Glb)
//                            context.insert(modelCom)
//                            entity.components.set(
//                                modelCom
//                            )
//    
//                            let anchor1 = ARGeoAnchor(coordinate: CLLocationCoordinate2D(latitude: 51.491345, longitude: -0.103119), altitude: 50)
//                            let anchorEntity1 = AnchorEntity(anchor: anchor1)
//                            anchorEntity1.addChild(entity)
//    
//                            arView.scene.addAnchor(anchorEntity1)
//                        }
    
                        if let entity = event.scene.findEntity(named: "1") {
                            let modelCom = ModelCom(uniqueKey: "1", lastUpdatedAtBlock: 0, key: Data("0".makeBytes()), contentURI: contentURI.absoluteString, encodingFormat: .Glb)
                            context.insert(modelCom)
                            entity.components.set(
                                modelCom
                            )
                            
                            geoAnchorEntity.addChild(entity)
                        }
                        
//                                            if let entity = event.scene.findEntity(named: "3") {
//                                                let modelCom = ModelCom(uniqueKey: "3", lastUpdatedAtBlock: 0, key: Data("0".makeBytes()), contentHash: contentHash, encodingFormat: .Glb)
//                                                context.insert(modelCom)
//                                                entity.components.set(
//                                                    modelCom
//                                                )
//                        
//                                                let anchor1 = ARGeoAnchor(coordinate: CLLocationCoordinate2D(latitude: 51.488082, longitude: -0.109130))
//                                                let anchorEntity1 = AnchorEntity(anchor: anchor1)
//                                                anchorEntity1.addChild(entity)
//                        
//                                                arView.scene.addAnchor(anchorEntity1)
//                                            }
                        
                        cancellable?.cancel()
                    }
                }
                .onDisappear {
                    cancellable?.cancel()
                    arView.session.pause()
                }
            
            CoachingOverlayView(arView: arView)
        }
    }
}

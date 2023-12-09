//
//  WorldCameraView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-21.
//

import SwiftUI
import SwiftData
import Web3
import SwiftMUD
import CryptoSwift
import RealityKit
import ARKit
import Geohash

@MainActor
struct WorldCameraView: View {
    @Environment(\.web3) var web3: Task<Web3, Error>
    @Environment(\.storeActor) private var storeActor: StoreActor?
    
    private let arView: ARView = ARView(frame: .zero)
    private var storeSync: Task<StoreSync, Error> {
        Task.init {
            let web3 = try await web3.value
            let store = Store(storeActor: storeActor!)
            store.registerRecordType(tableName: "ImageCom", handler: ImageCom.self)
            store.registerRecordType(tableName: "ModelCom", handler: ModelCom.self)
            store.registerRecordType(tableName: "PositionCom", handler: PositionCom.self)
            store.registerRecordType(tableName: "OrientationCom", handler: OrientationCom.self)
            store.registerRecordType(tableName: "ScaleCom", handler: ScaleCom.self)
//            store.registerRecordType(tableName: "NFTCom", handler: NFTCom.self)
            return StoreSync(web3: web3, store: store)
        }
    }

    let worldAddress: String = "0x3904285496739BF5030d79C0CF259A569806F759"
    let parcelId: UInt = 320
    var namespace: Bytes {
        Array("\(parcelId)".makeBytes()) + Array(repeating: 0, count: 11)
    }
    
    var body: some View {
        ZStack {
            AugmentCameraViewRepresentable(arView: arView, inputComponents: [])
                .task(priority: .background) {
                    do {
                        // Sync logs
                        try await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
                        
                        // Subscribe to logs
                        //                    try await storeSync.value.subscribeToLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
                        
                        let positionComs = try await storeActor?.fetchPositionComs() ?? []
                        let orientationComs = try await storeActor?.fetchOrientationComs() ?? []
                        let scaleComs = try await storeActor?.fetchScaleComs() ?? []
                        let modelComs = try await storeActor?.fetchModelComs() ?? []
//                        let nftComs = try modelContext.fetch(FetchDescriptor<NFTCom>())
                        let imageComs = try await storeActor?.fetchImageComs() ?? []
                        
                        let anchor = AnchorEntity(world: simd_float3(x: 0, y: 0, z: 0))
                        arView.scene.addAnchor(anchor)
                        
                        for com in positionComs {
                            let entity = Entity()
                            entity.name = com.key.toHexString()
                            entity.isEnabled = false
                            entity.components.set(com)
                            anchor.addChild(entity)
                            
                            if let geohash = com.geohash {
                                let geoAnchor = ARGeoAnchor(
                                    coordinate: CLLocationCoordinate2D(geohash: geohash)
                                )
                                arView.session.add(anchor: geoAnchor)
                                
                                let geoAnchorEntity = AnchorEntity(.anchor(identifier: geoAnchor.identifier))
                                geoAnchorEntity.name = "geo-\(entity.name)"
                                arView.scene.addAnchor(geoAnchorEntity)
                            }
                        }
                        
                        for com in orientationComs {
                            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
                            entity.components.set(com)
                        }
                        
                        for com in scaleComs {
                            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
                            entity.components.set(com)
                        }
                        
                        for com in modelComs {
                            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
                            entity.components.set(com)
                        }
                        
//                        for com in nftComs {
//                            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
//                            entity.components.set(com)
//                            await com.fetchNFTMetadata()
//                        }
                        
                        for com in imageComs {
                            guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
                            entity.components.set(com)
                        }
                    } catch {
                        print(error)
                    }
                }
            
            CoachingOverlayView(arView: arView)
        }
    }
}

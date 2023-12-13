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
    
    @Query var positionComs: [PositionCom]
    @Query var orientationComs: [OrientationCom]
    @Query var scaleComs: [ScaleCom]
    @Query var modelComs: [ModelCom]
    @Query var imageComs: [ImageCom]
    
    var body: some View {
        ZStack {
            AugmentCameraViewRepresentable(
                arView: arView,
                inputComponents: [],
                positionComs: positionComs, 
                orientationComs: orientationComs,
                scaleComs: scaleComs,
                modelComs: modelComs,
                imageComs: imageComs
            )
                .task(priority: .background) {
                    do {
                        // Sync logs
                        try await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
                        
                        // Subscribe to logs
                        //                    try await storeSync.value.subscribeToLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
                    } catch {
                        print(error)
                    }
                }
            
            CoachingOverlayView(arView: arView)
        }
    }
}

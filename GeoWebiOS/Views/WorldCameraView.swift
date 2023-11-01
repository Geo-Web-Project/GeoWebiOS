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

struct WorldCameraView: View {
    @Environment(\.web3) var web3: Task<Web3, Error>
    @Environment(\.modelContext) private var modelContext
    
    private let arView: ARView = ARView(frame: .zero)
    private var storeSync: Task<StoreSync, Error> {
        Task.init {
            let web3 = try await web3.value
            let store = Store(modelContext: modelContext)
            store.registerRecordType(tableName: "ImageCom", handler: ImageCom.self)
            store.registerRecordType(tableName: "ModelCom", handler: ModelCom.self)
            store.registerRecordType(tableName: "PositionCom", handler: PositionCom.self)
            store.registerRecordType(tableName: "NFTCom", handler: NFTCom.self)
            return StoreSync(modelContext: modelContext, web3: web3, store: store)
        }
    }

    let worldAddress: String = "0x000a18F809049257BfE86009de80990375475f4c"
    let parcelId: UInt = 320
    var namespace: Bytes {
        Array("\(parcelId)".makeBytes()) + Array(repeating: 0, count: 11)
    }
    
    var body: some View {
        AugmentCameraViewRepresentable(arView: arView, inputComponents: [])
            .task(priority: .background) {
                do {
                    /*
                     * - Load components once from chain
                     * - Add each entity + component to RealityKit if has PositionCom
                     */
                    
                    // Sync logs
                    try await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
                    
                    let positionComs = try modelContext.fetch(FetchDescriptor<PositionCom>())
                    let modelComs = try modelContext.fetch(FetchDescriptor<ModelCom>())
                    let nftComs = try modelContext.fetch(FetchDescriptor<NFTCom>())
                    let imageComs = try modelContext.fetch(FetchDescriptor<ImageCom>())
                    
                    let anchor = AnchorEntity(world: simd_float3(x: 0, y: 0, z: 0))
                    arView.scene.addAnchor(anchor)

                    for com in positionComs {
                        let entity = Entity()
                        entity.name = com.key.toHexString()
                        entity.components.set(com)
                        entity.isEnabled = false
                        
                        entity.components.set(AugmentInputComponent(inputTypes: [PositionCom.self]))
                        anchor.addChild(entity)
                    }
                    
                    for com in modelComs {
                        guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
                        entity.components.set(com)
                    }
                    
                    for com in nftComs {
                        guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
                        entity.components.set(com)
                        await com.fetchNFTMetadata()
                    }
                    
                    for com in imageComs {
                        guard let entity = arView.scene.findEntity(named: com.key.toHexString()) else { continue }
                        entity.components.set(com)
                    }
                } catch {
                    print(error)
                }
            }
    }
}

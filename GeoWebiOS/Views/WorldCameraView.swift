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
import SwiftGraphQL
import SwiftGraphQLClient

@MainActor
struct WorldCameraView: View {
    @Environment(\.web3) var web3: Task<Web3, Error>
    @Environment(\.storeActor) private var storeActor: StoreActor?
    @Environment(\.graphQLClient) private var graphQLClient: SwiftGraphQLClient.Client
    
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
    private static let parcelSelection = Selection.GeoWebParcel<String> {
        return try $0.id()
    }
    private static let parcelQuery = Selection.Query<[String]> {
        try $0.geoWebParcels(
            where: ~InputObjects.GeoWebParcelFilter(id: "0x140"),
            subgraphError: .deny,
            selection: parcelSelection.list
        )
    }

    private static let worldAddress: String = "0x3904285496739BF5030d79C0CF259A569806F759"
    
    @State private var namespaces: [Bytes] = []
    @Query private var positionComs: [PositionCom]
    @Query private var orientationComs: [OrientationCom]
    @Query private var scaleComs: [ScaleCom]
    @Query private var modelComs: [ModelCom]
    @Query private var imageComs: [ImageCom]
    
    var body: some View {
        ZStack {
            AugmentCameraViewRepresentable(
                arView: arView,
                inputComponents: [],
                positionComs: positionComs.filter{ filterParcelIds(record: $0) },
                orientationComs: orientationComs.filter{ filterParcelIds(record: $0) },
                scaleComs: scaleComs.filter{ filterParcelIds(record: $0) },
                modelComs: modelComs.filter{ filterParcelIds(record: $0) },
                imageComs: imageComs.filter{ filterParcelIds(record: $0) }
            )
                .task(priority: .background) {
                    do {
                        let parcelIds = try await graphQLClient.query(WorldCameraView.parcelQuery)
                        
                        self.namespaces = parcelIds.data.map { getNamespace(parcelIdHex: $0) }
                        
                        for parcelId in parcelIds.data {
                            // Sync logs
                            print("Syncing logs \(parcelId)...")
                            try await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: WorldCameraView.worldAddress)!, namespace: getNamespace(parcelIdHex: parcelId))
                            print("Synced logs \(parcelId)")
                            
                            // Subscribe to logs
                            //                    try await storeSync.value.subscribeToLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
                        }
                    } catch {
                        print(error)
                    }
                }
            
            CoachingOverlayView(arView: arView)
        }
    }
    
    private func filterParcelIds(record: Record) -> Bool {
        guard let namespaceId = record.table?.namespace?.namespaceId else { return false }
        return namespaces.contains(Bytes(hex: namespaceId))
    }
    
    private func getNamespace(parcelIdHex: String) -> Bytes {
        return Array("\(Int(hexString: String(parcelIdHex.dropFirst(2)))!)".makeBytes()) + Array(repeating: 0, count: 11)
    }
}

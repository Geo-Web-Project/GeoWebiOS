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
    private static let parcelSelection = Selection.GeoWebParcel<GeoWebParcel> {
        let bboxE = try? $0.bboxE()
        let bboxS = try? $0.bboxS()
        let bboxN = try? $0.bboxN()
        let bboxW = try? $0.bboxW()
        let tokenURI = try? $0.tokenUri()
        
        return GeoWebParcel(
            id: try $0.id(),
            bboxE: bboxE != nil ? CLLocationDegrees(truncating: Decimal(string: bboxE!)! as NSNumber): nil,
            bboxW: bboxW != nil ? CLLocationDegrees(truncating: Decimal(string: bboxW!)! as NSNumber): nil,
            bboxN: bboxN != nil ? CLLocationDegrees(truncating: Decimal(string: bboxN!)! as NSNumber): nil, 
            bboxS: bboxS != nil ? CLLocationDegrees(truncating: Decimal(string: bboxS!)! as NSNumber): nil,
            tokenURI: tokenURI
        )
    }
    
    private let locationManager: CLLocationManager = CLLocationManager()
    @State private var lastLocation = CLLocation()
    
    private static let worldAddress: String = "0x3904285496739BF5030d79C0CF259A569806F759"
    
    @Query(filter: #Predicate<GeoWebParcel> {
        $0.distanceAway ?? 100 < 100
    }, sort: \.distanceAway, order: .forward) private var parcels: [GeoWebParcel]
    private var namespaces: [Bytes] {
        parcels.map { getNamespace(parcelIdHex: $0.id) }
    }
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
                .task {
                    syncParcelNamespaces()

                    if self.locationManager.authorizationStatus == .notDetermined {
                        self.locationManager.requestWhenInUseAuthorization()
                    }
                                        
                    do {
                        let updates = CLLocationUpdate.liveUpdates()
                        for try await update in updates {
                            guard let loc = update.location else { continue }
                                                        
                            try await storeActor?.updateParcelsDistanceAway(currentUserLocation: loc.coordinate)

                            if self.lastLocation.distance(from: loc) > 50 && loc.speed < 10 {
                                // Query graph
                                try await performParcelQuery(location: loc.coordinate)
                                                                
                                self.lastLocation = loc
                            }
                        }
                    } catch {
                        print("Parcel Query Error: \(error)")
                    }
                }
                .onChange(of: parcels) {
                    syncParcelNamespaces()
                }
            
            CoachingOverlayView(arView: arView)
        }
    }
    
    private func filterParcelIds(record: Record) -> Bool {
        guard let namespaceId = record.table?.namespace?.namespaceId else { return false }
        return namespaces.contains(Bytes(hex: namespaceId))
    }
    
    private func getNamespace(parcelIdHex: String) -> Bytes {
        let bytes = Array("\(Int(hexString: String(parcelIdHex.dropFirst(2)))!)".makeBytes())
        return bytes + Array(repeating: 0, count: 14-bytes.count)
    }
    
    private func performParcelQuery(location: CLLocationCoordinate2D) async throws {
        let parcelQuery = Selection.Query<[GeoWebParcel]> {
            try $0.geoWebParcels(
                where: ~InputObjects.GeoWebParcelFilter(
                    bboxNGt: ~String(location.latitude - 0.00045),
                    bboxSLt: ~String(location.latitude + 0.00045),
                    bboxEGt: ~String(location.longitude - 0.00045),
                    bboxWLt: ~String(location.longitude + 0.00045)
                ),
                subgraphError: .deny,
                selection: WorldCameraView.parcelSelection.list
            )
        }
        
        let parcels = try await graphQLClient.query(parcelQuery)
        try await storeActor?.updateParcels(currentUserLocation: location, parcels: parcels.data)
    }
    
    private func syncParcelNamespaces() {
        print("Syncing parcels...")
        for parcel in parcels {
            Task.detached {
                // Sync logs
                print("Syncing logs \(parcel.id)...")
                try await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: WorldCameraView.worldAddress)!, namespace: getNamespace(parcelIdHex: parcel.id))
                print("Synced logs \(parcel.id)")
                
                // Subscribe to logs
                //                    try await storeSync.value.subscribeToLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
            }
        }
    }
}

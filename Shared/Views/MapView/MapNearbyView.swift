//
//  MapNearbyView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2024-01-03.
//

import SwiftUI
import SwiftData
import MapKit
import Web3
import SwiftMUD
import SwiftGraphQL
import SwiftGraphQLClient

struct MapNearbyView: View {
    @Environment(\.graphQLClient) private var graphQLClient: SwiftGraphQLClient.Client
    @Environment(\.storeActor) private var storeActor: StoreActor?

    @Query(filter: #Predicate<GeoWebParcel> {
        $0.distanceAway ?? 1000 < 1000
    }, sort: \.distanceAway, order: .forward) private var parcels: [GeoWebParcel]
    private var namespaces: [Bytes] {
        parcels.map { getNamespace(parcelIdHex: $0.id) }
    }
    
    @Query private var positionComs: [PositionCom]
    
    @SwiftUI.Namespace var mapScope
    @State var mapPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var lastMapRegion: MKCoordinateRegion? = nil
    
    var body: some View {
        MapReader { proxy in
            Map(position: $mapPosition, scope: mapScope) {
                ForEach(parcels) { parcel in
                    if let coords = parcel.clCoordinates {
                        MapPolygon(coordinates: coords)
                            .foregroundStyle(
                                .accent
                                    .opacity(0.5)
                            )
                    }
                }
                
                ForEach(positionComs.filter{ filterParcelIds(record: $0) }) { positionCom in
                    if let geohash = positionCom.geohash {
                        Marker("", systemImage: "arkit", coordinate: CLLocationCoordinate2D(geohash: geohash))
                    }
                }
                
                UserAnnotation()
            }
            .mapScope(mapScope)
        }.onMapCameraChange { context in
            Task.detached {
                if let lastMapRegion = lastMapRegion {
                    self.lastMapRegion = context.region

                    if context.region.center.latitude > (lastMapRegion.center.latitude + lastMapRegion.span.latitudeDelta) ||
                        context.region.center.latitude < (lastMapRegion.center.latitude - lastMapRegion.span.latitudeDelta) ||
                        context.region.center.longitude > (lastMapRegion.center.longitude + lastMapRegion.span.longitudeDelta) ||
                        context.region.center.longitude < (lastMapRegion.center.longitude - lastMapRegion.span.longitudeDelta) {
                        
                        try await performParcelQuery(region: context.region)
                    }
                } else {
                    self.lastMapRegion = context.region

                    try await performParcelQuery(region: context.region)
                }
            }
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
    
    private func performParcelQuery(region: MKCoordinateRegion) async throws {
        print("Querying for parcels in region: \(region)")

        let parcelQuery = Selection.Query<[GeoWebParcel]> {
            try $0.geoWebParcels(
                where: ~InputObjects.GeoWebParcelFilter(
                    bboxNGt: ~String(region.center.latitude - region.span.latitudeDelta),
                    bboxSLt: ~String(region.center.latitude + region.span.latitudeDelta),
                    bboxEGt: ~String(region.center.longitude - region.span.longitudeDelta),
                    bboxWLt: ~String(region.center.longitude + region.span.longitudeDelta)
                ),
                subgraphError: .deny,
                selection: WorldCameraView.parcelSelection.list
            )
        }
        
        let parcels = try await graphQLClient.query(parcelQuery)
        if let currentUserLocation = CLLocationManager().location?.coordinate {
            try await storeActor?.updateParcels(currentUserLocation: currentUserLocation, parcels: parcels.data)
        }
    }
}

#Preview {
    MapNearbyView()
}

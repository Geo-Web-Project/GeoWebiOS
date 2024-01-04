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

struct MapNearbyView: View {
    @Query(filter: #Predicate<GeoWebParcel> {
        $0.distanceAway ?? 1000 < 1000
    }, sort: \.distanceAway, order: .forward) private var parcels: [GeoWebParcel]
    private var namespaces: [Bytes] {
        parcels.map { getNamespace(parcelIdHex: $0.id) }
    }
    
    @Query private var positionComs: [PositionCom]
    
    @SwiftUI.Namespace var mapScope
    @State var mapPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
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
    }
    
    private func filterParcelIds(record: Record) -> Bool {
        guard let namespaceId = record.table?.namespace?.namespaceId else { return false }
        return namespaces.contains(Bytes(hex: namespaceId))
    }
    
    private func getNamespace(parcelIdHex: String) -> Bytes {
        return Array("\(Int(hexString: String(parcelIdHex.dropFirst(2)))!)".makeBytes()) + Array(repeating: 0, count: 11)
    }
}

#Preview {
    MapNearbyView()
}

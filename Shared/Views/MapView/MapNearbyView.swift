//
//  MapNearbyView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2024-01-03.
//

import SwiftUI
import SwiftData
import MapKit

struct MapNearbyView: View {
    @Query(filter: #Predicate<GeoWebParcel> {
        $0.distanceAway ?? 1000 < 1000
    }, sort: \.distanceAway, order: .forward) private var parcels: [GeoWebParcel]
    
    @Namespace var mapScope
    
    var body: some View {
        Map(scope: mapScope) {
            ForEach(parcels) { parcel in
                if let coords = parcel.clCoordinates {
                    MapPolygon(coordinates: coords)
                        .foregroundStyle(
                            .accent
                                .opacity(0.5)
                        )
                }
            }
            
            UserAnnotation()
        }
        .mapScope(mapScope)
    }
}

#Preview {
    MapNearbyView()
}

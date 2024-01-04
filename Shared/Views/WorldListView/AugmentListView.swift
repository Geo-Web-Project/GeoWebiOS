//
//  AugmentListView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-16.
//

import SwiftUI
import SwiftData

struct AugmentListView: View {
    @Query(filter: #Predicate<GeoWebParcel> {
        $0.distanceAway ?? 1000 < 1000
    }, sort: \.distanceAway, order: .forward) private var parcels: [GeoWebParcel]
    
    var body: some View {
        List(parcels) { parcel in
            AugmentListItem(
                title: parcel.id,
                distanceAway: parcel.distanceAway,
                isLoading: false,
                iconName: "square.2.layers.3d.top.filled"
            )
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .listRowBackground(Color.background)
            .listRowSeparator(.hidden, edges: .all)
            .listSectionSeparator(.hidden, edges: .all)
            
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        AugmentListView()
    }
}

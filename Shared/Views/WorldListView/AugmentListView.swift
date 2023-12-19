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
    }, sort: \.distanceAway, order: .reverse) private var parcels: [GeoWebParcel]
    
    var body: some View {
        List(parcels) { parcel in
            ParcelPreviewSmallCell(parcel: parcel)
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

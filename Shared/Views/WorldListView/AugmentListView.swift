//
//  AugmentListView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-16.
//

import SwiftUI
import SwiftData
import SwiftMUD

struct AugmentListView: View {
    @Environment(\.storeActor) private var storeActor: StoreActor?

    @Query(filter: #Predicate<GeoWebParcel> {
        $0.distanceAway ?? 1000 < 1000
    }, sort: \.distanceAway, order: .forward) private var parcels: [GeoWebParcel]
    
    @State private var isLoading = false
    
    var body: some View {
        List(parcels) { parcel in
            AugmentListItem(
                title: parcel.name ?? parcel.id,
                subtitle: parcel.externalURL, 
                distanceAway: parcel.distanceAway,
                isLoading: isLoading,
                iconName: "square.2.layers.3d.top.filled"
            )
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .listRowBackground(Color.background)
            .listRowSeparator(.hidden, edges: .all)
            .listSectionSeparator(.hidden, edges: .all)
            
        }
        .listStyle(.plain)
        .task {
            // Update all parcel metadata
            for parcel in parcels {
                print("Fetching metadata for parcel: \(parcel.id)")
                isLoading = true
                do {
                    try await storeActor?.updateParcelMetadata(parcel: parcel)
                    
                    print("Fetched metadata for parcel: \(parcel.id)")
                } catch {
                    print("Error fetching parcel metadata: \(error)")
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        AugmentListView()
    }
}

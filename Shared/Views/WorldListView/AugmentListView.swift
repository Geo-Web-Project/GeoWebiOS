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
            HStack {
                Image(systemName: "square.2.layers.3d.top.filled")
                    .imageScale(.large)
                VStack(alignment: .leading) {
                    Text(parcel.id)
                        .font(.headline)
    //                Text("https://geoweb.network")
    //                    .font(.subheadline)
    //                    .tint(.secondary)
                }
                .fontWeight(.semibold)

                Spacer()

                if let distanceAway = parcel.distanceAway {
                    VStack {
                        Image(systemName: "mappin.and.ellipse")
                        if distanceAway == 0 {
                            Text("Current")
                                .font(.caption)
                        } else {
                            Text("\(String(format: "%.0f", distanceAway)) m.")
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
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

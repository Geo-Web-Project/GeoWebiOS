//
//  ParcelPreviewSmallCell.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-12-18.
//

import SwiftUI
import SwiftData

struct ParcelPreviewSmallCell: View {
    @Bindable var parcel: GeoWebParcel
    
    var body: some View {
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
    }
}

#Preview {
    let container = try! ModelContainer(for: GeoWebParcel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let parcel = GeoWebParcel(id: "0x1")
    parcel.distanceAway = 10.5
                                        
    return ParcelPreviewSmallCell(
        parcel: parcel
    )
    .background(.thinMaterial)
    .padding()
    .modelContainer(container)
}

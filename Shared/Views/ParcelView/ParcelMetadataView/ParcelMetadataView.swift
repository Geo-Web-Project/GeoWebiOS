//
//  ParcelMetadataView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-16.
//

import SwiftUI
import MapKit

struct ParcelMetadataView: View {
    private let coors = [
        CLLocationCoordinate2D(latitude: 40.6898832321167, longitude: -74.04553413391113),
        CLLocationCoordinate2D(latitude: 40.6898832321167, longitude: -74.04313087463379),
        CLLocationCoordinate2D(latitude: 40.6884241104126, longitude: -74.04313087463379),
        CLLocationCoordinate2D(latitude: 40.6884241104126, longitude: -74.04553413391113),
    ]
    
    var body: some View {
        HStack(alignment: .top) {
            Map {
                MapPolygon(coordinates: coors)
                    .foregroundStyle(
                        .mint
                        .opacity(0.5)
                    )
            }
            .disabled(true)
            .aspectRatio(1.25, contentMode: .fit)
            .frame(width: 100)
            .padding()
            
            VStack(alignment: .leading){
                Text("For Sale Price: 0.005 ETHx")
                Text("Parcel ID: 0x1f")
                Text("Licensee: 0xef13f....2342")
            }
            .padding(.top)
            
            Spacer()
        }
    }
}

#Preview {
    ParcelMetadataView()
}

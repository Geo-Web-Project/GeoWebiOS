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
        HStack(alignment: .center) {
            Map {
                MapPolygon(coordinates: coors)
                    .foregroundStyle(
                        .mint
                        .opacity(0.5)
                    )
            }
            .disabled(true)
            .frame(width: 125, height: 100)
                        
            VStack(alignment: .leading){
                Text("Price: 0.005 ETHx")
                Text("Parcel ID: 0x1f")
                Text("Licensee: 0xef13f....2342")
            }
            
            Spacer()
        }
    }
}

#Preview {
    ParcelMetadataView()
        .padding()
}

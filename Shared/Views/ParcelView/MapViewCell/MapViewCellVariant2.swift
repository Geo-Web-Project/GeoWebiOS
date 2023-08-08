//
//  MapViewCellVariant2.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import MapKit

struct MapViewCellVariant2: View {
    @State private var isPresentingMapView = false
    
    private let coors = [
        CLLocationCoordinate2D(latitude: 40.6898832321167, longitude: -74.04553413391113),
        CLLocationCoordinate2D(latitude: 40.6898832321167, longitude: -74.04313087463379),
        CLLocationCoordinate2D(latitude: 40.6884241104126, longitude: -74.04313087463379),
        CLLocationCoordinate2D(latitude: 40.6884241104126, longitude: -74.04553413391113),
    ]

    var body: some View {
        Button(action: {
            isPresentingMapView = true
        }, label: {
            GroupBox(
                label: Label("Map", systemImage: "map")
                    .font(.caption)
                    .textCase(.uppercase)
            ) {
                Map {
                    MapPolygon(coordinates: coors)
                        .foregroundStyle(
                            .mint
                            .opacity(0.5)
                        )
                }
                .disabled(true)
            }.aspectRatio(1.0, contentMode: .fit)
        })
        .sheet(isPresented: $isPresentingMapView) {
            FullMapView(isPresenting: $isPresentingMapView)
        }
    }
}

#Preview {
    MapViewCellVariant2()
        .padding()
}

#Preview {
    MapViewCellVariant2()
        .frame(width: 200, height: 200)
        .padding()
}

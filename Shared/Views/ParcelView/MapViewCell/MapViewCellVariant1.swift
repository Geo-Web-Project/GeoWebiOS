//
//  MapViewCellVariant1.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import MapKit

struct MapViewCellVariant1: View {
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
                    .font(.subheadline)
            ) {
                Map {
                    MapPolygon(coordinates: coors)
                        .foregroundStyle(
                            .mint
                            .opacity(0.5)
                        )
                }
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }.aspectRatio(1.0, contentMode: .fit)
        })
        .fullScreenCover(isPresented: $isPresentingMapView) {
            FullMapView(isPresenting: $isPresentingMapView)
        }
    }
}

#Preview {
    MapViewCellVariant1()
        .padding()
}

#Preview {
    MapViewCellVariant1()
        .frame(width: 200, height: 200)
        .padding()
}

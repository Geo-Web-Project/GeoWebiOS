//
//  FullMapView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-28.
//

import SwiftUI
import MapKit

struct FullMapView: View {
    private let coors = [
        CLLocationCoordinate2D(latitude: 40.6898832321167, longitude: -74.04553413391113),
        CLLocationCoordinate2D(latitude: 40.6898832321167, longitude: -74.04313087463379),
        CLLocationCoordinate2D(latitude: 40.6884241104126, longitude: -74.04313087463379),
        CLLocationCoordinate2D(latitude: 40.6884241104126, longitude: -74.04553413391113),
    ]
    
    @Namespace var mapScope
    @Binding var isPresenting: Bool
    
    var body: some View {
        Map(scope: mapScope) {
            MapPolygon(coordinates: coors)
                .foregroundStyle(
                    .mint
                    .opacity(0.5)
                )
            UserAnnotation()
        }
        .overlay(alignment: .topTrailing) {
            HStack(alignment: .top) {
                Button(action: {
                    isPresenting = false
                }, label: {
                    Text("Done")
                        .padding(10)
                })
                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(.leading)
            
                Spacer()
                
                VStack {
                    MapUserLocationButton(scope: mapScope)
                    MapCompass(scope: mapScope)
                        .mapControlVisibility(.visible)
                }
            }
            .padding(.trailing, 10)
            .padding(.top, 20)
            .buttonBorderShape(.roundedRectangle)
        }
        .mapScope(mapScope)
    }
}

#Preview {
    FullMapView(isPresenting: Binding.constant(true))
}

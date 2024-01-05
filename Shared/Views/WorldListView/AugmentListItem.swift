//
//  AugmentListItem.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2024-01-04.
//

import SwiftUI
import CoreLocation

struct AugmentListItem: View {
    var title: String
    var subtitle: String?
    var distanceAway: CLLocationDistance?
    var isLoading: Bool
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
            .fontWeight(.semibold)

            Spacer()
            
            if isLoading {
                ProgressView()
                    .padding(.trailing, 5)
            } else if let distanceAway {
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
        .foregroundStyle(isLoading ? .tertiary : .primary)
        .padding()
    }
}

#Preview {
    AugmentListItem(
        title: "Central Park",
        subtitle: "https://geoweb.network",
        distanceAway: CLLocationDistance(),
        isLoading: false,
        iconName: "square.2.layers.3d.top.filled"
    )
}

#Preview {
    AugmentListItem(
        title: "Central Park",
        subtitle: "https://geoweb.network",
        distanceAway: CLLocationDistance(),
        isLoading: true,
        iconName: "square.2.layers.3d.top.filled"
    )
}

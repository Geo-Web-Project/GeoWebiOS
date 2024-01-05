//
//  GeoAccuracyView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2024-01-05.
//

import SwiftUI
import ARKit

struct GeoAccuracyView: View {
    var state: ARGeoTrackingStatus.State
    var accuracy: ARGeoTrackingStatus.Accuracy
    
    private var text: String {
        switch accuracy {
        case .low:
            return "Low"
        case .medium:
            return "Med"
        case .high:
            return "High"
        default:
            return ""
        }
    }
    
    var body: some View {
        VStack {
            switch state {
            case .localized:
                Image(systemName: "mappin.and.ellipse")
                
                Text(text)
                    .font(.caption)
            case .notAvailable:
                Image(systemName: "mappin.slash")
                    .imageScale(.large)
                    .foregroundStyle(.red)
            default:
                ProgressView()
            }
        }
        .padding()
        .frame(width: 60, height: 60)
        .background(.ultraThinMaterial, in: .circle)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    GeoAccuracyView(state: .localized, accuracy: .high)
}

#Preview {
    GeoAccuracyView(state: .localized, accuracy: .medium)
}

#Preview {
    GeoAccuracyView(state: .localized, accuracy: .low)
}

#Preview {
    GeoAccuracyView(state: .initializing, accuracy: .low)
}

#Preview {
    GeoAccuracyView(state: .localizing, accuracy: .low)
}

#Preview {
    GeoAccuracyView(state: .notAvailable, accuracy: .low)
}

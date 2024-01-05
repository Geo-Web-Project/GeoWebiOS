//
//  AnchorCountView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2024-01-05.
//

import SwiftUI

struct AnchorCountView: View {
    var anchorCount: Int
    
    var body: some View {
        VStack {
            Image(systemName: "arkit")
            
            Text("\(anchorCount)")
                .font(.caption)
        }
        .padding()
        .frame(width: 60, height: 60)
        .background(.ultraThinMaterial, in: .circle)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    AnchorCountView(anchorCount: 10)
}

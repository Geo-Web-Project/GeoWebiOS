//
//  AugmentCellVariant1.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-18.
//

import SwiftUI

struct AugmentCellVariant1: View {
    var body: some View {
        GroupBox(label:
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .imageScale(.large)
                VStack(alignment: .leading) {
                    Text("Buddha")
                        .font(.headline)
                    Text("Image")
                        .font(.caption)
                }
                .fontWeight(.semibold)
            }
        ) {
            Image("sample-favicon")
                .padding()
                .frame(minHeight: 150)
        }
    }
}

#Preview {
    AugmentCellVariant1()
}

//
//  AugmentCellVariant3.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-18.
//

import SwiftUI

struct AugmentCellVariant3: View {
    var body: some View {
        GroupBox(label:
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .imageScale(.large)
                VStack(alignment: .leading) {
                    Text("Buddha")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Image")
                        .font(.caption2)
                }
            }
        ) {
            Image("sample-favicon")
                .padding()
                .frame(minHeight: 150)
        }
    }
}

#Preview {
    AugmentCellVariant3()
}

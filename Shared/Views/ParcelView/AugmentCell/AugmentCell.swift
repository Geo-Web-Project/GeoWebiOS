//
//  AugmentCell.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-16.
//

import SwiftUI

struct AugmentCell: View {
    var body: some View {
        GroupBox(label:
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .imageScale(.large)
                VStack(alignment: .leading) {
                    Text("Buddha")
                        .font(.headline)
                    Text("Model")
                        .font(.subheadline)
                }
                .fontWeight(.semibold)
            }
        ) {
            ModelSceneView(mediaObject: StubMediaObjectFixtures.model)
                .frame(minHeight: 150)
        }
    }
}

#Preview {
    AugmentCell()
        .padding()
}

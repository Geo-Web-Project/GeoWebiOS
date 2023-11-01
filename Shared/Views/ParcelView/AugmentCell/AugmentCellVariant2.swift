//
//  AugmentCellVariant2.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-18.
//

import SwiftUI

struct AugmentCellVariant2: View {
    var body: some View {
        GroupBox(label:
            HStack(alignment: .top) {
                VStack(alignment: .center) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .imageScale(.large)
                    Text("Image")
                        .font(.caption2)
                }
                .padding(.trailing, 5)
            
                Text("Buddha")
                    .font(.title)
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
    AugmentCellVariant2()
}

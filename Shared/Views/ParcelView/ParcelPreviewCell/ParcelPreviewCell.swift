//
//  ParcelPreviewCell.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-16.
//

import SwiftUI

struct ParcelPreviewCell: View {
    var body: some View {
        GroupBox(label:
            HStack {
                Image(systemName: "square.2.layers.3d.top.filled")
                    .imageScale(.large)
                VStack(alignment: .leading) {
                    Text("Central Park")
                        .font(.headline)
                    Text("https://geoweb.network")
                        .font(.subheadline)
                }
                .fontWeight(.semibold)
            }
        ) {
            ZStack {
                TabView {
                    Image("sample-favicon")
                        .padding()
                    
                    Image("sample-favicon")
                        .padding()
                }
                .tabViewStyle(.page)
                
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Image(systemName: "mappin.and.ellipse")
                        Text("100 ft.")
                            .font(.caption)
                    }

                }
            }
            .frame(height: 200)
        }
    }
}

#Preview {
    ParcelPreviewCell()
        .padding()
}

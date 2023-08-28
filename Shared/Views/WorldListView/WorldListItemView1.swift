//
//  WorldListItemView1.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-08-28.
//

import SwiftUI

struct WorldListItemView1: View {
    var hasWebContent: Bool
    var hasMediaGallery: Bool
    var hasARContent: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Parcel Name")
                    .font(.title2)
                    .bold()
                Text("1 mile away")
                    .font(.subheadline)
            }
            Spacer()
            GroupBox {
                Grid {
                    GridRow {
                        Image(systemName: "safari")
                            .foregroundStyle(hasWebContent ? .primary : .quaternary)
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundStyle(hasMediaGallery ? .primary : .quaternary)
                    }.padding(.bottom)
                    GridRow {
                        Image(systemName: "viewfinder")
                            .foregroundStyle(hasARContent ? .primary : .quaternary)
                    }
                }
            }
            .backgroundStyle(.thinMaterial)
        }
    }
}

#Preview {
    WorldListItemView1(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
}

#Preview {
    List {
        WorldListItemView1(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
        WorldListItemView1(hasWebContent: true, hasMediaGallery: true, hasARContent: false)
        WorldListItemView1(hasWebContent: true, hasMediaGallery: false, hasARContent: true)
        WorldListItemView1(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
    }
}

//
//  ParcelListItemView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-27.
//

import SwiftUI
import MapKit

struct ParcelListItemView: View {
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
    ParcelListItemView(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
}

#Preview {
    List {
        ParcelListItemView(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
        ParcelListItemView(hasWebContent: true, hasMediaGallery: true, hasARContent: false)
        ParcelListItemView(hasWebContent: true, hasMediaGallery: false, hasARContent: true)
        ParcelListItemView(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
    }
}

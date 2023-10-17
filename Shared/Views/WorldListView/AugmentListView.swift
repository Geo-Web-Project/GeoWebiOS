//
//  AugmentListView.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-10-16.
//

import SwiftUI

struct AugmentListView: View {
    var body: some View {
        List {
            ParcelPreviewCell()
                .listRowSeparator(.hidden)
            AugmentCell()
                .listRowSeparator(.hidden)
            ParcelPreviewCell()
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle("Nearby")
    }
}

#Preview {
    NavigationView {
        AugmentListView()
    }
}

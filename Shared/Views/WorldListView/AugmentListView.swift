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
                .listRowBackground(Color.clear)
            AugmentCell()
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            ParcelPreviewCell()
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            AugmentCellVariant2()
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            AugmentCellVariant3()
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .navigationTitle("Nearby")
        .navigationBarTitleDisplayMode(.large)
        .background(Color("BackgroundColor"))
        .backgroundStyle(.thinMaterial)
    }
}

#Preview {
    NavigationStack {
        AugmentListView()
    }
}

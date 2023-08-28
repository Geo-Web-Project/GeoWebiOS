//
//  ParcelListView2.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-08-07.
//

import SwiftUI

struct ParcelListView2: View {
    @Binding var isPresenting: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Button(action: {
                    withAnimation(.snappy(duration: 0.2)) {
                        isPresenting = false
                    }
                }, label: {
                    WorldListItemView1(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
                    Image(systemName: "chevron.right")
                })
                .buttonStyle(.borderless)
                .foregroundStyle(.primary)
                
                WorldListItemView1(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                WorldListItemView1(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
                WorldListItemView1(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                WorldListItemView1(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
                WorldListItemView1(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                WorldListItemView1(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
            }
            .navigationTitle("Parcels")
            .navigationBarTitleDisplayMode(.large)
            .listRowSpacing(10)
        }
    }
}

#Preview {
    NavigationStack {
        ParcelListView2(isPresenting: Binding.constant(true))
    }
}

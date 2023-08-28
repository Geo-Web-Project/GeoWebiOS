//
//  ParcelListView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-27.
//

import SwiftUI

struct ParcelListView: View {
    @Binding var isPresenting: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Label("Within 1 mile", systemImage: "location.fill")
                .padding()
            List {
                NavigationLink(destination: {
                    NavigationStack {
                        ParcelViewGridLarge(isARAvailable: true)
                    }
                }, label: {
                    WorldListItemView(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
                })
                Button(action: {
                    withAnimation(.snappy(duration: 0.2)) {
                        isPresenting = false
                    }
                }, label: {
                    WorldListItemView(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
                    Image(systemName: "chevron.right")
                })
                .buttonStyle(.borderless)
                .foregroundStyle(.primary)
                
                WorldListItemView(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                WorldListItemView(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
                WorldListItemView(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                WorldListItemView(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
                WorldListItemView(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                WorldListItemView(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
            }
            .navigationTitle("Parcels")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    NavigationStack {
        ParcelListView(isPresenting: Binding.constant(true))
    }
}

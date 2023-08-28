//
//  ParcelListView.swift
//  HubbleDesigns
//
//  Created by Cody Hatfield on 2023-07-27.
//

import SwiftUI

struct ParcelListView: View {   
    @State private var isPresentingWorldView: Bool = false

    var body: some View {
        if isPresentingWorldView {
            ParcelViewGridLarge(isPresentingWorldView: $isPresentingWorldView, isARAvailable: true)
                .transition(.scale(-2))
        } else {
            VStack(alignment: .leading) {
                Label("Within 1 mile", systemImage: "location.fill")
                    .padding()
                List {
                    NavigationLink(destination: {
                        NavigationStack {
                            ParcelViewGridLarge(isPresentingWorldView: $isPresentingWorldView, isARAvailable: true)
                        }
                    }, label: {
                        WorldListItemView1(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
                    })
                    Button(action: {
                        withAnimation(.snappy(duration: 0.2)) {
                            isPresentingWorldView = true
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
            }
        }
    }
}

#Preview {
    NavigationStack {
        ParcelListView()
    }
}

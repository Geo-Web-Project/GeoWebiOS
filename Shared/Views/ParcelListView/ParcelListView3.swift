//
//  ParcelListView3.swift
//  GeoWebiOSDesigns
//
//  Created by Cody Hatfield on 2023-08-07.
//

import SwiftUI

struct ParcelListView3: View {
    @State private var selection: String = "Nearby"
    @State private var isFormPresented: Bool = false
    @State private var isFilterPresented: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ParcelListItemView(hasWebContent: true, hasMediaGallery: true, hasARContent: true)
                ParcelListItemView(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                ParcelListItemView(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
                ParcelListItemView(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                ParcelListItemView(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
                ParcelListItemView(hasWebContent: false, hasMediaGallery: true, hasARContent: true)
                ParcelListItemView(hasWebContent: false, hasMediaGallery: false, hasARContent: true)
            }
            .listRowSpacing(10)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("", selection: $selection) {
                    ForEach(["Nearby", "Saved"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isFormPresented = true
                }, label: {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $isFormPresented, content: {
                    AddWorldFormView(isPresented: $isFormPresented)
                })
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    isFilterPresented = true
                }, label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                })
                .popover(isPresented: $isFilterPresented, content: {
                    List {
                        Label("Media Gallery", systemImage: "photo.on.rectangle.angled")
                        Label("Splant", systemImage: "waveform.circle")
                        Label("Archly", systemImage: "photo.on.rectangle.angled")
                    }
                    .listStyle(.plain)
                    .frame(minWidth: 250, minHeight: 200)
                    .presentationCompactAdaptation(.popover)
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        ParcelListView3()
    }
}

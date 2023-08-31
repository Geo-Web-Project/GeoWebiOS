//
//  WorldView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-21.
//

import SwiftUI
import SwiftData
import Web3

struct WorldView: View {
    @Environment(\.storeSync) var storeSync: Task<StoreSync, Error>
    @Environment(\.modelContext) private var modelContext

    var worldAddress: String
    
    private var namePredicate: Predicate<Name> {
        #Predicate<Name> { name in
            name.worldAddress == worldAddress
        }
    }
    private var urlPredicate: Predicate<Url> {
        #Predicate<Url> { url in
            url.worldAddress == worldAddress
        }
    }
    private var mediaObjectPredicate: Predicate<MediaObject> {
        #Predicate<MediaObject> { mediaObject in
            mediaObject.worldAddress == worldAddress
        }
    }
    private var isAnchorPredicate: Predicate<IsAnchorComponent> {
        #Predicate<IsAnchorComponent> { obj in
            obj.worldAddress == worldAddress && obj.value == true
        }
    }
    
    @Query private var name: [Name]
    @Query private var url: [Url]
    @Query private var mediaObjects: [MediaObject]
    @Query private var isAnchorComponent: [IsAnchorComponent]

    @State private var isPresentingMapView = false
    
    init(worldAddress: String) {
        self.worldAddress = worldAddress
        
        _name = Query(filter: namePredicate)
        _url = Query(filter: urlPredicate)
        _mediaObjects = Query(filter: mediaObjectPredicate)
        _isAnchorComponent = Query(filter: isAnchorPredicate)
    }
    
    var body: some View {
        ScrollView {
            Grid {
                if isAnchorComponent.count > 0 {
                    EnterARButton(worldAddress: worldAddress)
                }
                
                GridRow {
                    if let url = url.first?.value {
                        WebViewCell(uri: url)
                    }
                    
                    MapViewCell()
                }
                
                MediaGalleryCell(mediaObjects: mediaObjects)
                
                Spacer()
            }.padding()
        }
        .navigationTitle(name.first?.value ?? "")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color("BackgroundColor"))
        .background(Color("BackgroundColor"))
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button(action: {
                        isPresentingMapView = true
                    }, label: {
                        Image(systemName: "map")
                    })
                    Spacer()
//                    Button(action: {}, label: {
//                        Image(systemName: "list.bullet")
//                    })
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentingMapView) {
            FullMapView(isPresenting: $isPresentingMapView)
        }
        .task {
            do {
                // 1. Start subscription to events
                try await storeSync.value.subscribeToLogs(worldAddress: EthereumAddress(hexString: worldAddress)!)
                
                // 2. Sync logs
                try await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: worldAddress)!)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorldView(worldAddress: "")
            .modelContainer(for: [WorldSync.self, Name.self, Url.self, MediaObject.self])
    }
}

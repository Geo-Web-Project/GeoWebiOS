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
    @Environment(\.storeSync) var storeSync: StoreSync?
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
    
    @Query private var name: [Name]
    @Query private var url: [Url]
    @Query private var mediaObjects: [MediaObject]
    
    @State private var isPresentingMapView = false
    
    init(worldAddress: String) {
        self.worldAddress = worldAddress
        
        _name = Query(filter: namePredicate)
        _url = Query(filter: urlPredicate)
        _mediaObjects = Query(filter: mediaObjectPredicate)
    }
    
    var body: some View {
        ScrollView {
            Grid {
//                if (isARAvailable) {
//                    EnterARButton()
//                }
                
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
        .onAppear {
            // 1. Start subscription to events
            try! storeSync?.subscribeToLogs(worldAddress: EthereumAddress(hexString: worldAddress)!)
            
            // 2. Sync logs
            do {
                try storeSync?.syncLogs(worldAddress: EthereumAddress(hexString: worldAddress)!)
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

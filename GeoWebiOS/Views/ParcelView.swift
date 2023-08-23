//
//  ParcelView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-21.
//

import SwiftUI
import SwiftData
import Web3

struct ParcelView: View {
    @Environment(\.modelContext) private var modelContext

    private static let worldAddress = "0xc6916BE3968f43BEBDf6c20874fFDCE74adF1352"
    
    private static let namePredicate = #Predicate<Name> { name in
        name.worldAddress == worldAddress
    }
    private static let urlPredicate = #Predicate<Url> { url in
        url.worldAddress == worldAddress
    }
    private static let mediaObjectPredicate = #Predicate<MediaObject> { mediaObject in
        mediaObject.worldAddress == worldAddress
    }
    
    @Query(filter: namePredicate)
    private var name: [Name]
    
    @Query(filter: urlPredicate)
    private var url: [Url]
    
    @Query(filter: mediaObjectPredicate)
    private var mediaObjects: [MediaObject]
    
    @State private var isPresentingMapView = false
    
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
            guard let apiKey = ProcessInfo.processInfo.environment["ALCHEMY_API_KEY"] else {
                return
            }
            
            let web3 = try! Web3(wsUrl: "wss://opt-goerli.g.alchemy.com/v2/\(apiKey)")
            let storeSync = StoreSync(modelContext: modelContext, web3: web3, worldAddress: EthereumAddress(hexString: ParcelView.worldAddress)!)
            
            // 1. Start subscription to events
            try! storeSync.subscribeToLogs()
            
            // 2. Sync logs
            do {
                try storeSync.syncLogs()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ParcelView()
            .modelContainer(for: [WorldSync.self, Name.self, Url.self, MediaObject.self])
    }
}

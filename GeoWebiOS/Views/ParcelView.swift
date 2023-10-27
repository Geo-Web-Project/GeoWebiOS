//
//  ParcelView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-21.
//

import SwiftUI
import SwiftData
import Web3
import SwiftMUD
import CryptoSwift

struct ParcelView: View {
    @Environment(\.web3) var web3: Task<Web3, Error>
    @Environment(\.modelContext) private var modelContext
    private var storeSync: Task<StoreSync, Error> {
        Task.init {
            let web3 = try await web3.value
            let store = Store(modelContext: modelContext)
            store.registerRecordType(tableName: "NameCom", handler: NameCom.self)
            return StoreSync(modelContext: modelContext, web3: web3, store: store)
        }
    }

    let worldAddress: String = "0xF794E6e465749150aDEC12F23667171C045Aa1e2"
    var parcelId: UInt
    var namespace: Bytes {
        Array(SHA3(variant: .keccak256).calculate(for: parcelId.makeBytes())[0..<14])
    }
    
    private var namePredicate: Predicate<NameCom> {
        #Predicate<NameCom> { name in
            true
        }
    }
    
    @Query private var name: [NameCom]

    @State private var isPresentingMapView = false
    
    init(parcelId: UInt) {
        self.parcelId = parcelId
        
        _name = Query(filter: namePredicate)
    }
    
    var body: some View {
        ScrollView {
            
        }
        .navigationTitle(name.first?.value ?? "Loading...")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color("BackgroundColor"))
        .background(Color("BackgroundColor"))
        .task(priority: .background) {
            do {
                // 1. Start subscription to events
                try await storeSync.value.subscribeToLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
                
                // 2. Sync logs
                try await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: worldAddress)!, namespace: namespace)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ParcelView(parcelId: 0)
            .modelContainer(for: [World.self, NameCom.self], inMemory: true)
    }
}

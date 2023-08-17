//
//  ContentView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-08.
//

import SwiftUI
import SwiftData
import Web3

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    private static let worldAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
    
    private static let namePredicate = #Predicate<Name> { name in
        name.worldAddress == worldAddress
    }
    private static let urlPredicate = #Predicate<Url> { url in
        url.worldAddress == worldAddress
    }
    
    @Query(filter: namePredicate)
    private var name: [Name]
    
    @Query(filter: urlPredicate)
    private var url: [Url]

    var body: some View {
        VStack {
            if let first = name.first {
                Text(first.value)
                    .font(.title)
            } else {
                Text("No name found")
            }
            if let first = url.first {
                Text(first.value)
                    .font(.subheadline)
            } else {
                Text("No url found")
            }
        }.onAppear {
            let web3 = try! Web3(wsUrl: "ws://127.0.0.1:8545")
            let storeSync = StoreSync(modelContext: modelContext, web3: web3, worldAddress: EthereumAddress(hexString: ContentView.worldAddress)!)
            
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
    ContentView()
        .modelContainer(for: Name.self, inMemory: true)
}

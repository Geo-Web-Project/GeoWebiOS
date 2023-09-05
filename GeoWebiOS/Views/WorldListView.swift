//
//  WorldListView.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-28.
//

import SwiftUI
import SwiftData
import Web3

struct WorldListView: View {
    @Environment(\.web3) var web3: Task<Web3, Error>
    @Environment(\.modelContext) private var context

    @State private var isFormPresented: Bool = false
    @Query private var savedWorlds: [SavedWorld]
    
    private var storeSync: Task<StoreSync, Error> {
        Task.init {
            let web3 = try await web3.value
            return StoreSync(modelContext: context, web3: web3)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            NavigationStack {
                List(savedWorlds) { world in
                    NavigationLink(destination: {
                        WorldView(worldAddress: world.worldAddress)
                    }, label: {
                        WorldListItemView(worldAddress: world.worldAddress)
                    })
                }
            }
        }
        .navigationTitle("Worlds")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isFormPresented = true
                }, label: {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $isFormPresented, content: {
                    AddWorldFormView(submit: {(_, worldAddress) in
                        context.insert(
                            SavedWorld(
                                chainId: 420,
                                worldAddress: EthereumAddress(hexString: worldAddress)!
                            )
                        )
                        isFormPresented = false
                        
                        Task.init {
                            try? await storeSync.value.syncLogs(worldAddress: EthereumAddress(hexString: worldAddress)!)
                        }
                    }, cancel: {
                        isFormPresented = false
                    })
                })
            }
        }
        .task(priority: .background) {
            let fetch = FetchDescriptor<SavedWorld>()
            if let results = try? context.fetch(fetch) {
                if results.count == 0 {
                    // Insert default world
                    let worldAddress = try! EthereumAddress(hex: "0x95daBD4e205630ea766133d6c67d4ABcD9d22142", eip55: true)
                    context.insert(
                        SavedWorld(
                            chainId: 420,
                            worldAddress: worldAddress
                        )
                    )
                                        
                    do {
                        try await storeSync.value.syncLogs(worldAddress: worldAddress)
                    } catch {
                        print(error)
                    }
                }
                
                for result in results {
                    // Sync state
                    if let worldAddress = EthereumAddress(hexString: result.worldAddress) {
                        do {
                            try await storeSync.value.syncLogs(worldAddress: worldAddress)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        .environment(\.storeSync, storeSync)
    }
}

#Preview {
    NavigationStack {
        WorldListView()
            .modelContainer(for: SavedWorld.self, inMemory: true)
    }
}

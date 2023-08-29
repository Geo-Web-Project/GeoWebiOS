//
//  GeoWebiOSApp.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-08.
//

import SwiftUI
import SwiftData
import Web3

private struct Web3Key: EnvironmentKey {
    static let defaultValue: Web3 = try! Web3(wsUrl: "wss://opt-goerli.g.alchemy.com/v2/\(ProcessInfo.processInfo.environment["ALCHEMY_API_KEY"]!)")
}

private struct StoreSyncKey: EnvironmentKey {
    static let defaultValue: StoreSync? = nil
}

extension EnvironmentValues {
    var web3: Web3 {
        get { self[Web3Key.self] }
        set { self[Web3Key.self] = newValue }
    }
    
    var storeSync: StoreSync? {
        get { self[StoreSyncKey.self] }
        set { self[StoreSyncKey.self] = newValue }
    }
}

@main
struct GeoWebiOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WorldListView()
            }
        }
        .environment(\.web3, Web3Key.defaultValue)
        .modelContainer(for: [SavedWorld.self, WorldSync.self, Name.self, Url.self, MediaObject.self])
    }
}

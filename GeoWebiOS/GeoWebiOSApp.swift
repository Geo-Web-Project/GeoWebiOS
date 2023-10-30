//
//  GeoWebiOSApp.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-08.
//

import SwiftUI
import SwiftData
import Web3
import SwiftMUD

private struct Web3Key: EnvironmentKey {
    static let defaultValue: Task<Web3, Swift.Error> = Task.detached {
//        try Web3(wsUrl: "ws://localhost:8545")
        try Web3(wsUrl: "wss://opt-goerli.g.alchemy.com/v2/\(Bundle.main.infoDictionary!["ALCHEMY_API_KEY"] as! String)")
    }
}

private struct StoreSyncKey: EnvironmentKey {
    enum StoreSyncError: Error {
        case NotImplemented
    }
    
    static let defaultValue: Task<StoreSync, Swift.Error> = Task {
        throw StoreSyncError.NotImplemented
    }
}

extension EnvironmentValues {
    var web3: Task<Web3, Swift.Error> {
        get { self[Web3Key.self] }
        set { self[Web3Key.self] = newValue }
    }
    
    var storeSync: Task<StoreSync, Swift.Error> {
        get { self[StoreSyncKey.self] }
        set { self[StoreSyncKey.self] = newValue }
    }
}

@main
struct GeoWebiOSApp: App {
    @State private var augmentAddrStr: String = ""
    @State private var isPresenting = false

    var body: some Scene {
        WindowGroup {
//            NavigationStack {
//                ParcelView(parcelId: 320)
//            }
            VStack {
                TextField("Augment Address", text: $augmentAddrStr)
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical)
                Button(action: {
                    if (try? EthereumAddress(hex: augmentAddrStr, eip55: false)) != nil {
                        isPresenting = true
                    }
                }, label: {
                    Text("Preview Augment")
                })
            }.padding()
            .fullScreenCover(isPresented: $isPresenting, content: {
                AugmentPreviewView(augmentAddress: try! EthereumAddress(hex: augmentAddrStr, eip55: false))
            })
        }
        .environment(\.web3, Web3Key.defaultValue)
        .modelContainer(for: [
            World.self,
            ImageCom.self,
            NFTCom.self
        ], inMemory: true)
    }
}

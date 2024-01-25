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
import SwiftGraphQL
import SwiftGraphQLClient

private struct Web3Key: EnvironmentKey {
    static let defaultValue: Task<Web3, Swift.Error> = Task.detached {
//        try Web3(wsUrl: "ws://localhost:8545")
        try Web3(wsUrl: Bundle.main.infoDictionary!["ETH_RPC_WS"] as! String)
    }
}

private struct StoreActorKey: EnvironmentKey {
    enum StoreActorError: Error {
        case NotImplemented
    }
    
    static let defaultValue: StoreActor? = nil
}

private struct StoreSyncKey: EnvironmentKey {
    enum StoreSyncError: Error {
        case NotImplemented
    }
    
    static let defaultValue: Task<StoreSync, Swift.Error> = Task {
        throw StoreSyncError.NotImplemented
    }
}

private struct GraphQLClientKey: EnvironmentKey {
    enum GraphQLClientError: Error {
        case NotImplemented
    }
    
    static let defaultValue: SwiftGraphQLClient.Client = SwiftGraphQLClient.Client(request: URLRequest(url:  URL(string: Bundle.main.infoDictionary!["SUBGRAPH_URI"] as! String)!))
}

extension EnvironmentValues {
    var web3: Task<Web3, Swift.Error> {
        get { self[Web3Key.self] }
        set { self[Web3Key.self] = newValue }
    }
    
    var storeActor: StoreActor? {
        get { self[StoreActorKey.self] }
        set { self[StoreActorKey.self] = newValue }
    }
    
    var storeSync: Task<StoreSync, Swift.Error> {
        get { self[StoreSyncKey.self] }
        set { self[StoreSyncKey.self] = newValue }
    }
    
    var graphQLClient: SwiftGraphQLClient.Client {
        get { self[GraphQLClientKey.self] }
        set { self[GraphQLClientKey.self] = newValue }
    }
}

@main
struct GeoWebiOSApp: App {
    let container = try! ModelContainer(
        for: World.self,
            GeoWebParcel.self,
            PositionCom.self,
            OrientationCom.self,
            ScaleCom.self,
            ModelCom.self,
            ImageCom.self
    )
    
    @State private var selectedTabView: Int? = nil
    
    var body: some Scene {
        WindowGroup {
            TabSheetView {
                WorldCameraView()
            }
            .onAppear {
                print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
                
            }
        }
        .environment(\.web3, Web3Key.defaultValue)
        .environment(\.storeActor, StoreActor(modelContainer: container))
        .modelContainer(container)
    }
}

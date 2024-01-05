//
//  GeoWebiOSDesignsApp.swift
//  GeoWebiOSDesignsApp
//
//  Created by Cody Hatfield on 2023-07-27.
//

import SwiftUI
import SwiftMUD
import SwiftData

private struct StoreActorKey: EnvironmentKey {
    enum StoreActorError: Error {
        case NotImplemented
    }
    
    static let defaultValue: StoreActor? = nil
}

extension EnvironmentValues {
    var storeActor: StoreActor? {
        get { self[StoreActorKey.self] }
        set { self[StoreActorKey.self] = newValue }
    }
}


@main
struct GeoWebiOSDesignsApp: App {
    let container = try! ModelContainer(
        for: World.self,
            GeoWebParcel.self,
            PositionCom.self,
            OrientationCom.self,
            ScaleCom.self,
            ModelCom.self,
            ImageCom.self
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(\.storeActor, StoreActor(modelContainer: container))
    }
}

//
//  GeoWebiOSApp.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-08-08.
//

import SwiftUI
import SwiftData

@main
struct GeoWebiOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ParcelView()
            }
        }
        .modelContainer(for: [WorldSync.self, Name.self, Url.self, MediaObject.self])
    }
}

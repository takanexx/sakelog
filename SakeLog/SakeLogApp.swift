//
//  SakeLogApp.swift
//  SakeLog
//
//  Created by Takane on 2025/10/05.
//

import SwiftUI
import RealmSwift

@main
struct SakeLogApp: SwiftUI.App {
    @StateObject private var userManager = UserManager()
    
    let realmConfig = Realm.Configuration(
        schemaVersion: 1,
        deleteRealmIfMigrationNeeded: false
    )

    var body: some Scene {
        WindowGroup {
            Group {
                if userManager.currentUser != nil {
                    ContentView()
                } else {
                    StartView()
                }
            }
            .environmentObject(userManager)
            .environment(\.realmConfiguration, realmConfig)
        }
    }
}

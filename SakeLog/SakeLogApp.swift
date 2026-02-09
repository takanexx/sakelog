//
//  SakeLogApp.swift
//  SakeLog
//
//  Created by Takane on 2025/10/05.
//

import SwiftUI
import RealmSwift
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SakeLogApp: SwiftUI.App {
    // Firebase 初期化
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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

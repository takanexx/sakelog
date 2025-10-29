import SwiftUI
import SceneKit
import RealmSwift

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            CabinetView()
                .tabItem {
                    Label("Cabinet", systemImage: "cabinet.fill")
                }
            SettingView()
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
        }
        .tint(colorScheme == .dark ? .white : .black)
        .environment(\.realmConfiguration, Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: false))
    }
}

#Preview {
    ContentView()
}


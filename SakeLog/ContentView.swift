import SwiftUI
import SceneKit
import RealmSwift

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            NavigationStack {
                CabinetView()
                    .navigationTitle("Cabinet")
                    .navigationBarTitleDisplayMode(.inline) // タイトルを小さく中央寄せ
            }
            .tabItem {
                Label("Cabinet", systemImage: "cabinet.fill")
            }
            SettingView()
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
        }
        .tint(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    ContentView()
}


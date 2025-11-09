//
//  StartView.swift
//  SakeLog
//
//  Created by Takane on 2025/11/06.
//
import SwiftUI
import RealmSwift

// モデル定義
struct Item: Identifiable {
    let id = UUID()
    let icon: String
    let description: String
}

// データ定義
let items: [Item] = [
    Item(icon: "🍶", description: "お気に入りの日本酒を記録しよう"),
    Item(icon: "📷", description: "ラベルを撮って\n自分だけの酒ログに"),
    Item(icon: "🤮", description: "飲み過ぎにはご注意を🍀"),
]

struct CarouselView: View {
    @Binding var currentIndex: Int  // ページインデックスを外部から監視


    var body: some View {
        TabView (selection: $currentIndex) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.1))
                        .shadow(radius: 4)
                    VStack(alignment: .center) {
                        Text(item.icon)
                            .font(.system(size: 80))
                        Text(item.description)
                            .font(.title3)
                            .padding(.top, 10)
                    }
                }
                .padding()
                .tag(index + 1) // 各ページにタグを付与
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 450)
    }
}


struct StartView: View {
    @State private var currentIndex = 1  // 現在のページ
    @State private var navigateToMain = false   // 遷移状態を管理

    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Welcome to SakeLog")
                    .font(.largeTitle)
                    .padding()
                Text("Your personal sake tasting journal.")
                    .font(.subheadline)
                    .padding()
                CarouselView(currentIndex: $currentIndex)
                
                Spacer()
                
                Text("\(currentIndex)")
                Button(action: {
                    // Action to get started
                    let user = User(
                        username: "ゲストユーザー",
                        email: "",
                    )
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(user)
                    }
                    // ContentView へ移動する処理をここに追加
                    navigateToMain = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isAtLastPage ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isAtLastPage) // 最後のページまで進まないと押せない
                .padding(.horizontal)
            }
            .padding()
            .animation(.easeInOut, value: currentIndex)
            .navigationDestination(isPresented: $navigateToMain) {
                ContentView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    /// 最後のページにいるかどうか
    private var isAtLastPage: Bool {
        currentIndex == 3
    }
}

#Preview {
    StartView()
}

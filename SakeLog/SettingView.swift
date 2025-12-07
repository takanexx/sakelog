//
//  SettingView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/13.
//


import SwiftUI
import SceneKit
import RealmSwift

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var userManager = UserManager()
    @State private var showAlert = false
    @State private var isOn = false

    var body: some View {
        List() {
            Section(header: Text("Account")) {
//                Label("プロフィール", systemImage: "person.circle")
//                    .foregroundColor(colorScheme == .dark ? .white : .black)
                HStack{
                    Label("プラン", systemImage: "star")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    Text("\(userManager.currentUser?.plan ?? "Free")")
                        .bold()
                }
                HStack {
                    Label("テーマ", systemImage: "paintbrush")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    Text("\(getThemeName())")
                        .bold()
                }
            }
            Section(header: Text("App")) {
                HStack {
                    Text("バージョン")
                    Spacer()
                    Text("1.0.0")
                        .bold()
                }
                Text("利用規約")
                Text("プライバシーポリシー")
            }
            Section() {
                Button(role: .destructive) {
                    showAlert = true
                } label: {
                    Text("アカウントを削除")
                }
            }
            .alert("確認", isPresented: $showAlert) {
                Button("削除", role: .destructive) {
                    try! Realm().write {
                        try! Realm().deleteAll()
                    }
                    print("削除しました")
                }
                Button("キャンセル", role: .cancel) { }
            } message: {
                Text("データを全て削除してもよろしいですか？")
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func getThemeName() -> String {
        if colorScheme == .dark {
            return "ダーク"
        } else if colorScheme == .light {
            return "ライト"
        } else {
            return "システム"
        }
    }
}

#Preview {
    SettingView()
}


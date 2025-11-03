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
    @State private var showAlert = false
    
    var body: some View {
        List() {
            Section(header: Text("Account")) {
                Text("Profile")
                Text("Privacy")
            }
            Section(header: Text("Notifications")) {
                Toggle(isOn: .constant(true)) {
                    Text("Push Notifications")
                }
                Toggle(isOn: .constant(false)) {
                    Text("Email Notifications")
                }
            }
            Section(header: Text("About")) {
                Text("Version 1.0.0")
                Text("Terms of Service")
                Text("Privacy Policy")
            }
            Section(header: Text("Danger Zone")) {
                Button(role: .destructive) {
                    showAlert = true
                } label: {
                    Text("Delete Account")
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
    
   
}

#Preview {
    SettingView()
}


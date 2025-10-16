//
//  SettingView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/13.
//


import SwiftUI
import SceneKit

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
        }
        .listStyle(InsetGroupedListStyle())
    }
    
   
}

#Preview {
    SettingView()
}


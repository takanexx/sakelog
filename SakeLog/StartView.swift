//
//  StartView.swift
//  SakeLog
//
//  Created by Takane on 2025/11/06.
//
import SwiftUI

struct StartView: View {
    var body: some View {
        VStack {
            Text("Welcome to SakeLog")
                .font(.largeTitle)
                .padding()
            Text("Your personal sake tasting journal.")
                .font(.subheadline)
                .padding()
            Spacer()
            Button(action: {
                // Action to get started
            }) {
                Text("Get Started")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    StartView()
}

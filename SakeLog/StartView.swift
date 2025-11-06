//
//  StartView.swift
//  SakeLog
//
//  Created by Takane on 2025/11/06.
//
import SwiftUI

struct CarouselView: View {
    let items = ["🍶", "🍷", "🍺", "🥃", "🍸"]
    @Binding var currentIndex: Int  // ページインデックスを外部から監視


    var body: some View {
        TabView (selection: $currentIndex) {
            ForEach(items.indices, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.1))
                        .shadow(radius: 4)
                    Text(items[index])
                        .font(.system(size: 80))
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
    @State private var currentIndex = 1  // ← 現在のページ

    var body: some View {
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
    }
    
    /// 最後のページにいるかどうか
    private var isAtLastPage: Bool {
        currentIndex == 5
    }
}

#Preview {
    StartView()
}

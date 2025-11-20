//
//  HomeView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/13.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
                    ScrollView {
                        GeometryReader { geo in
                            let minY = geo.frame(in: .global).minY
                            let height = max(600 - minY, 150)  // 縮む上限・下限

                            ZStack(alignment: .bottomLeading) {
                                ModelRenderView(labelImageName: "izumi", allowsCameraControl: false)
                                    .frame(height: height)
                                    .clipped()

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Promoted")
                                        .font(.caption)

                                    Text("Round-the-clock\nwellness")
                                        .font(.title.bold())

                                    Button("Shop now") { }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(.white.opacity(0.9))
                                        .cornerRadius(20)
                                }
                                .padding(20)
                                .shadow(radius: 5)
                            }
                            .background(Color.gray.opacity(0.1))
                            .frame(height: height)
                            .offset(y: minY > 0 ? -minY : 0)  // 上に引っ張られた時の処理
                        }
                        .frame(height: 600) // ←スクロール前の元高さ

                        // MARK: - SearchBar
//                        SearchBarView()
//                            .padding(.horizontal)
//                            .padding(.top, -10)
//
//                        // MARK: - Featured Stores
//                        FeaturedStoresView()
//                            .padding(.top, 10)

                    }
                    .navigationBarHidden(true)
                }
            
    }
}
            
#Preview {
    HomeView()
}

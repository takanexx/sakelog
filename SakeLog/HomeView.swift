//
//  HomeView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/13.
//
import SwiftUI
import RealmSwift

struct HomeView: View {
//    直近のSakeLogを取得
    @ObservedResults(SakeLog.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) private var recentSakeLogs
    @State private var brand: Brand? = nil  // 銘柄
    @State private var brewery: Brewery? = nil  // 酒蔵
    @State private var area: Area? = nil  // 酒蔵の地域
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    GeometryReader { geo in
                        let minY = geo.frame(in: .global).minY
                        let height = max(600 + minY, 150)  // 縮む上限・下限
                        
                        ZStack(alignment: .bottomLeading) {
                            if recentSakeLogs.isEmpty {
                                ModelRenderView(labelImageName: "izumi", allowsCameraControl: false)
                                    .frame(height: height)
                                    .clipped()
                            } else {
                                ModelRenderView(labelImageName: recentSakeLogs[0].labelUrl, allowsCameraControl: false)
                                    .frame(height: height)
                                    .clipped()
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                if (recentSakeLogs.isEmpty) {
                                    Text("Wlecome to SakeLog")
                                        .font(.largeTitle)
                                } else {
                                    Text("Recently Logged")
                                        .font(.caption)
                                }
                                
                                HStack (alignment: .firstTextBaseline, spacing: 10) {
                                    Text("🍶")
                                    Text("\(brand?.name ?? "Discover New Sakes")")
                                        .font(.title.bold())
                                    Text("\(brand?.brewery?.name ?? "")")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(20)
                            .shadow(radius: 5)
                        }
                        .background(Color.gray.opacity(0.1))
                        .frame(height: height)
                        .offset(y: -minY)
                    }
                    .frame(height: 600) // ←スクロール前の元高さ
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("今月の記録")
                            .font(.title2.bold())
                        VStack (alignment: .leading, spacing: 6) {
                            Text("🍶 12 本")
                            Text("🏷️ 大吟醸, 純米吟醸, その他")
                            Text("📍 北海道, 新潟, 愛知, その他3件")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await loadBrand()
        }
    }
    
    func loadBrand() async {
        self.brand = Brand.getBrandById(recentSakeLogs[0].brandId ?? 0)
    }
}

#Preview {
    HomeView()
}

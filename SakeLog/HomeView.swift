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
                    
                    
                    VStack(spacing: 20) {
//                        JapanMapView()
                        JapanHeatMapView()
//                        .frame(height: UIScreen.main.bounds.height * 0.45)  // ← 高さは画面に応じて決定
//                        .scaledToFit()
//                        .background(Color.gray.opacity(0.05))
                    }
                    .padding(.horizontal)

                    VStack {
                        Text("Featured Stores")
                            .frame(height: 400)
                            .foregroundColor(.red)
                    }
                }
                
                
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

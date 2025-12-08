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
    // 今月の記録
    @ObservedResults(SakeLog.self, where: {$0.date >= Date.startOfThisMonth && $0.date <= Date.endOfThisMonth}) private var thisMonthSakeLogs
    @State private var brand: Brand? = nil  // 銘柄
    @State private var brewery: Brewery? = nil  // 酒蔵
    @State private var area: Area? = nil  // 酒蔵の地域
    
    @State private var tip: SakeTip = sakeTips.randomElement()!

    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 最近のSakeLogラベル画像
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
                                    Text("最近飲んだ日本酒")
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
                    
                    // 日本酒豆知識
                    VStack(alignment: .leading, spacing: 8) {
                        Text("今日の日本酒豆知識")
                            .font(.title2.bold())

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.1))
                                .shadow(radius: 4)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(tip.emoji)
                                        .font(.title3)
                                    Text(tip.text)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Button(action: {
                                    tip = sakeTips.randomElement()!
                                }) {
                                    Text("別の豆知識を見る")
                                        .font(.footnote)
                                }
                                .padding(.top, 6)
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // 今月の記録
                    VStack(alignment: .leading, spacing: 10) {
                        Text("今月の記録")
                            .font(.title2.bold())
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.1))
                                .shadow(radius: 4)
                            VStack (alignment: .leading, spacing: 10) {
                                if thisMonthSakeLogs.isEmpty {
                                    Text("今月の記録はまだありません")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                } else {
                                    HStack (alignment: .center, spacing: 5) {
                                        Text("🍶")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Text("\(thisMonthSakeLogs.count)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("銘柄")
                                            .baselineOffset(-5)
                                    }
                                    HStack (alignment: .center, spacing: 5) {
                                        Text("🏷️")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        // 銘柄の名前を全て表示
                                        Text("\(Set(thisMonthSakeLogs.compactMap { Brand.getBrandById($0.brandId ?? 0)?.brewery?.name }).joined(separator: " 、"))")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        // 銘柄が多い場合はその他○件と表示
                                        if thisMonthSakeLogs.count > 3 {
                                            Text("その他\(thisMonthSakeLogs.count - 3)件")
                                        }
                                    }
                                    HStack (alignment: .center, spacing: 5) {
                                        Text("📍")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        // 地域の名前を全て表示
                                        Text("\(Set(thisMonthSakeLogs.compactMap { Brand.getBrandById($0.brandId ?? 0)?.brewery?.area?.name }).joined(separator: " 、"))")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        // 地域が多い場合はその他○件と表示
                                        if thisMonthSakeLogs.count > 3 {
                                            Text("その他\(thisMonthSakeLogs.count - 3)件")
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                        .padding(.vertical, 2)
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

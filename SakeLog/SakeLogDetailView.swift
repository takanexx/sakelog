//
//  SakeLogDetailView.swift
//  SakeLog
//
//  Created by Takane on 2025/11/12.
//

import SwiftUI
import RealmSwift

struct SakeLogDetailView: View {
    @ObservedRealmObject var sakeLog: SakeLog
    @State private var brand: Brand? = nil  // ← ここに格納

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // ラベル画像
                    ModelRenderView(labelImageName: sakeLog.labelUrl, allowsCameraControl: true)
                        .frame(height: 450)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 6)
                        .padding(.bottom, 8)
                    // ブランドIDからブランド名を取得して表示
                    Text("\(brand?.name ?? "不明なブランド")")
                        .font(.title)
                        .bold()

                    // 酒の種類
                    Text("種類: \(sakeLog.kind)")
                        .font(.headline)

                    // 評価
                    if let rating = sakeLog.rating {
                        Text("評価: \(rating)/5")
                            .font(.subheadline)
                    }

                    // メモ
                    if let notes = sakeLog.notes {
                        Text("メモ:")
                            .font(.headline)
                            .padding(.top, 4)
                        Text(notes)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // 日付
                    Text("登録日: \(sakeLog.date.formatted(date: .long, time: .omitted))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("酒ログ詳細")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await loadBrand()
        }
    }
    
    
    func loadBrand() async {
        self.brand = Brand.getBrandById(sakeLog.brandId ?? 0)
    }
}

#Preview {
    let config = Realm.Configuration(inMemoryIdentifier: "preview")
    let realm = try! Realm(configuration: config)

    let previewSakeLog = SakeLog()
    previewSakeLog.userId = ObjectId.generate()
    previewSakeLog.brandId = 101
    previewSakeLog.kind = "純米吟醸"
    previewSakeLog.labelUrl = "izumi"
    previewSakeLog.rating = 4
    previewSakeLog.notes = "華やかでフルーティーな香り。"

    try! realm.write {
        realm.add(previewSakeLog)
    }

    return SakeLogDetailView(sakeLog: previewSakeLog)
}



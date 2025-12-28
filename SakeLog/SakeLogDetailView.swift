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
    @State private var brand: Brand? = nil  // 銘柄
    @State private var brewery: Brewery? = nil  // 酒蔵
    @State private var area: Area? = nil  // 酒蔵の地域
    @State private var showAlert: Bool = false  // 削除確認アラート表示フラグ
    @Environment(\.dismiss) private var dismiss

    
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
                    HStack (alignment: .firstTextBaseline, spacing: 8) {
                        Text("🍶")
                            .font(.title)
                        Text("\(brand?.name ?? "不明なブランド")")
                            .font(.title)
                            .bold()
                        Text("\(sakeLog.kind)")
                            .foregroundColor(.secondary)
                            .bold()
                            .padding(.horizontal, 8)
                    }
                    HStack (alignment: .firstTextBaseline, spacing: 8) {
                        Text("📍")
                        Text("\(brand?.brewery?.name ?? "不明な酒蔵") / \(brand?.brewery?.area?.name ?? "不明な地域")")
                            .bold()
                    }
                    .font(.title3)

                    // 酒の種類
                        .font(.headline)

                    // 評価
                    if let rating = sakeLog.rating {
                        HStack {
                            Text("⭐️")
                            Text("評価: \(rating)/5")
                        }
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
            // 削除ボタン
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        // 確認のアラートを表示
                        showAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .alert("確認", isPresented: $showAlert) {
                Button("削除", role: .destructive) {
                    dismiss()
                    guard
                        let realm = try? Realm(),
                        let thawed = sakeLog.thaw()
                    else { return }

                    try? realm.write {
                        realm.delete(thawed)
                    }

                    print("削除しました")
                }
                Button("キャンセル", role: .cancel) { }
            } message: {
                Text("この酒ログを削除してもよろしいですか？")
            }
                    
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



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
    @State private var showEdit: Bool = false // 編集画面表示フラグ
    @State private var showAlert: Bool = false  // 削除確認アラート表示フラグ
    @State private var selectedType: String? // 酒の種類
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
                    Text("メモ:")
                        .font(.headline)
                        .padding(.top, 4)
                    Text(sakeLog.notes)
                        .font(.body)
                        .foregroundColor(.secondary)

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
            // 編集・削除ボタン
            .toolbar {
                Menu {
                    // 編集ボタン
                    NavigationLink(destination: EditBrandSheetView(
                        sakeLog: sakeLog,
                        selectedBrand: $brand,
                        selectedType: $selectedType
                    )) {
                        Label("編集", systemImage: "pencil")
                    }
                    // 削除ボタン
                    Button(role: .destructive) {
                        showAlert = true
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
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
        self.selectedType = sakeLog.kind
    }
}

#Preview {
    let config = Realm.Configuration(inMemoryIdentifier: "preview")
    let realm = try! Realm(configuration: config)

    let previewSakeLog = SakeLog()
    previewSakeLog.userId = ObjectId.generate()
    previewSakeLog.brandId = 101
    previewSakeLog.kind = "純米吟醸"
    previewSakeLog.labelUrl = "logo"
    previewSakeLog.rating = 4
    previewSakeLog.notes = "華やかでフルーティーな香り。"

    try! realm.write {
        realm.add(previewSakeLog)
    }

    return SakeLogDetailView(sakeLog: previewSakeLog)
}



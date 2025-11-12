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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // ラベル画像
                    ModelRenderView(labelImageName: sakeLog.labelUrl, allowsCameraControl: false)
                        .frame(height: 300)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 6)
                        .padding(.bottom, 8)

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
    }
}

#Preview {
    let previewSakeLog = SakeLog()
    previewSakeLog.userId = ObjectId.generate()
    previewSakeLog.brandId = 101
    previewSakeLog.kind = "純米吟醸"
    previewSakeLog.labelUrl = "izumi"
    previewSakeLog.rating = 4
    previewSakeLog.notes = "華やかでフルーティーな香り。食中酒としても◎。少し冷やすとより香りが引き立ちます。"
    
    SakeLogDetailView(sakeLog: previewSakeLog)
}


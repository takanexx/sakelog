//
//  AddBrandSheetView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/18.
//

import SwiftUI

struct AddBrandSheetView: View {
    @State private var memoText: String = ""
    @Binding var selectedBrand: Brand?
    @Binding var selectedType: String?
    
    let types = ["純米", "純米吟醸", "純米大吟醸", "特別純米", "生酒", "吟醸", "大吟醸", "その他"]
    // レイアウト
    let typeColumns = [
        GridItem(.adaptive(minimum: 100), spacing: 10) // 最小幅を指定
    ]
    
    var body: some View {
        // ブランドが選択されている場合は詳細表示、そうでなければリスト表示
        if selectedBrand != nil {
            ScrollView {
                VStack (alignment: .leading) {
                    // Brand Name
                    HStack {
                        Text("Brand Name")
                            .font(.headline)
                        Button("はずす") {
                            selectedBrand = nil
                        }
                    }
                    .padding(.bottom, 3)
                    HStack (alignment: .center, spacing: 12) {
                        Text("🍶 \(selectedBrand!.name)")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(selectedBrand!.brewery?.name ?? "")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .baselineOffset(-5)
                        Spacer()
                        Button(action: {
                            // 選択したブランドを削除する
                            selectedBrand = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Kind
                    Text("Kind")
                        .font(.headline)
                        .padding(.bottom, 5)
                    FlowLayout(alignment: .leading, spacing: 7) {
                        ForEach(types, id: \.self) { type in
                            Button(action: {
                                // 同じボタンを押したら解除、それ以外なら選択
                                if selectedType == type {
                                    selectedType = nil
                                } else {
                                    selectedType = type
                                }
                            }) {
                                Text(type)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 5)
                                    .frame(minWidth: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                selectedType == type ? Color.blue : Color.primary,
                                                lineWidth: 1
                                            )
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(
                                                        selectedType == type
                                                        ? Color.blue.opacity(0.1)
                                                        : Color.clear
                                                    )
                                            )
                                    )
                            }
                            .foregroundColor(selectedType == type ? .blue : .primary)
                            
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Label
                    Text("Label Image")
                        .font(.headline)
                        .padding(.bottom, 5)
                    HStack {
                        Button(action: {
                            // ラベル画像を変更する処理
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "photo.on.rectangle.angled") // 好きなSF Symbolアイコン
                                    .font(.system(size: 20))
                                Text("Select Label Image")
                                    .font(.headline)
                            }
                            .foregroundColor(.secondary)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                // 枠線はsecondayカラーで点線
                                    .strokeBorder(Color.secondary, style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.clear)
                                    )
                            )
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Memo
                    Text("Memo")
                        .font(.headline)
                        .padding(.bottom, 5)
                    TextEditor(text: $memoText)
                        .frame(height: 150)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(25)
                
                Button(action: {
                    // 保存処理
                }) {
                    Text("保存")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.primary)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                    // 枠線はsecondayカラーで点線
                        .strokeBorder(Color.primary, style: StrokeStyle(lineWidth: 1.5))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.clear)
                        )
                )
                .padding(25)
            }
        } else {
            BrandListView(selectedBrand: $selectedBrand)
        }
    }
}


#Preview {
    AddBrandSheetView(selectedBrand: .constant(nil), selectedType: .constant(nil))
}

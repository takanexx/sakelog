//
//  CabinetView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/13.
//
import SwiftUI
import SceneKit

struct CabinetView: View {
    @State private var isShow = false
    @State private var brand: Brand? = nil
    @State private var memoText: String = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<20) { index in
                        ModelRenderView(labelImageName: "izumi", allowsCameraControl: false)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Cabinet")
            .navigationBarTitleDisplayMode(.inline) // タイトルを小さく中央寄せ
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("右上ボタン tapped")
                        isShow.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShow) {
                // ブランドが選択されている場合は詳細表示、そうでなければリスト表示
                if brand != nil {
                    VStack (alignment: .leading) {
                        // Brand Name
                        HStack {
                            Text("Brand Name")
                                .font(.headline)
                            Button("はずす") {
                                brand = nil
                            }
                        }
                        .padding(.bottom, 3)
                        HStack (alignment: .center, spacing: 12) {
                            Text("🍶 \(brand!.name)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text(brand!.brewery?.name ?? "")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .baselineOffset(-5)
                            Spacer()
                            Button(action: {
                                // 選択したブランドを削除する
                                brand = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
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
                } else {
                    BrandListView(selectedBrand: $brand)
                }
            }
        }
    }
}

#Preview {
    CabinetView()
}

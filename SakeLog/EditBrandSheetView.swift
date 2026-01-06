//
//  EditBrandSheetView.swift
//  SakeLog
//
//  Created by Takane on 2026/01/07.
//

import SwiftUI
import PhotosUI
import UIKit
import RealmSwift

struct EditBrandSheetView: View {
    @Binding var selectedBrand: Brand?
    @Binding var selectedType: String?
    
    @State private var memoText: String = ""
    @State private var showChoiceDialog = false
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var croppedImage: UIImage?
    @State private var showCropView = false
    
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
                    // MARK: - Brand Name
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
                    
                    // MARK: - Kind
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
                                    // 軽い振動
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
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
                    
                    // MARK: - Label
                    Text("Label Image")
                        .font(.headline)
                        .padding(.bottom, 5)
                    if let image = croppedImage ?? selectedImage {
                        ZStack (alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                                )
                                .padding(.bottom, 30)
                            Button(action: {
                                // 画像をクリア
                                croppedImage = nil
                                selectedImage = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                                    .padding(8)
                            }
                        }
                    } else {
                        HStack {
                            Button(action: {
                                // ラベル画像を変更する処理
                                showChoiceDialog = true
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
                    }
                    
                    // MARK: - Memo
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
                    var labelFileName: String? = nil
                    // クロップ画像があればそちらを保存、なければ選択画像を保存
                    if let cropped = croppedImage {
                        labelFileName = saveImageToDocuments(image: cropped)
                    } else if let selected = selectedImage {
                        labelFileName = saveImageToDocuments(image: selected)
                    }
                    // ここで selectedBrand、selectedType、selectedImage、memoText を使って保存処理を行う
                    let newSakeLog = SakeLog(
                        userId: ObjectId(),
                        brandId: selectedBrand?.id,
                        kind: selectedType ?? "その他",
                        labelUrl: labelFileName ?? "",
                        rating: 0,
                        notes: memoText
                    )
                        
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(newSakeLog)
                    }
                    
                    // 保存後にシートを閉じる
                    selectedBrand = nil
                    selectedType = nil
                    selectedImage = nil
                    memoText = ""
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
                .padding(20)
            }
            .padding(.top, 15)
            .confirmationDialog("画像を選択", isPresented: $showChoiceDialog) {
                Button("カメラで撮影") { showCamera = true }
                Button("ライブラリから選択") { showPhotoPicker = true }
                Button("キャンセル", role: .cancel) {}
            }
            // ライブラリ選択
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPicker(image: $selectedImage)
            }
            // カメラ撮影
            .fullScreenCover(isPresented: $showCamera) {
                CameraPicker(image: $selectedImage)
            }
            .onChange(of: selectedImage) {
                guard let _ = selectedImage else { return }
                croppedImage = nil
                showCropView = true
            }
            .fullScreenCover(isPresented: $showCropView) {
                if let image = selectedImage {
                    CropImageView(
                        image: image.normalized(),
                        onComplete: { cropped in
                            self.croppedImage = cropped   // ← 保存用
                            showCropView = false
                        },
                        onCancel: {
                            self.selectedImage = nil
                            showCropView = false
                        }
                    )
                }
            }
        } else {
            BrandListView(selectedBrand: $selectedBrand)
        }
    }
}





#Preview {
    EditBrandSheetView(selectedBrand: .constant(nil), selectedType: .constant(nil))
}

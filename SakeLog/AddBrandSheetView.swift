//
//  AddBrandSheetView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/18.
//

import SwiftUI
import PhotosUI
import UIKit

struct AddBrandSheetView: View {
    @State private var memoText: String = ""
    @Binding var selectedBrand: Brand?
    @Binding var selectedType: String?
    
    @State private var showChoiceDialog = false
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    
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
                    if let image = selectedImage {
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
                                selectedImage = nil // 画像をクリア
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
        } else {
            BrandListView(selectedBrand: $selectedBrand)
        }
    }
}


// MARK: - フォトライブラリ
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        init(_ parent: PhotoPicker) { self.parent = parent }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

// MARK: - カメラ撮影
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}



#Preview {
    AddBrandSheetView(selectedBrand: .constant(nil), selectedType: .constant(nil))
}

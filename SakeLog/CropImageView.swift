//
//  CropImageView.swift
//  SakeLog
//
//  Created by Takane on 2025/12/22.
//
import SwiftUI

struct CropImageView: View {
    let image: UIImage
    let onComplete: (UIImage) -> Void
    let onCancel: () -> Void
    let cropSize: CGFloat = 300
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var gestureScale: CGFloat = 1.0
    @State private var gestureOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(scale * gestureScale)
                        .offset(
                            x: offset.width + gestureOffset.width,
                            y: offset.height + gestureOffset.height
                        )
                        .frame(width: cropSize, height: cropSize)
                        .clipped()
                        .gesture(dragGesture)
                        .gesture(magnificationGesture)


                    Rectangle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: cropSize, height: cropSize)
                }

                Spacer()

                HStack {
                    Button("キャンセル") {
                        onCancel()
                    }
                    .foregroundColor(.white)

                    Spacer()

                    Button("完了") {
                        let cropped = image.cropped(
                            scale: scale,
                            offset: offset,
                            cropSize: cropSize,
                        )
                        onComplete(cropped)
                    }
                    .foregroundColor(.white)
                }
                .padding()
            }
        }
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                gestureOffset = value.translation
            }
            .onEnded { value in
                offset.width += value.translation.width
                offset.height += value.translation.height
                gestureOffset = .zero
            }
    }

    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                gestureScale = value
            }
            .onEnded { value in
                scale = max(scale * value, 1.0) // 最小倍率
                gestureScale = 1.0
            }
    }
}


// UIImage トリミング用 Extension
extension UIImage {
    func cropped(
        scale: CGFloat,
        offset: CGSize,
        cropSize: CGFloat
    ) -> UIImage {

        guard let cgImage else { return self }

        let imageSize = CGSize(
            width: cgImage.width,
            height: cgImage.height
        )

        // scaledToFill の基準スケール
        let baseScale = max(
            cropSize / imageSize.width,
            cropSize / imageSize.height
        )

        let totalScale = baseScale * scale

        // 表示されている画像サイズ
        let displayedSize = CGSize(
            width: imageSize.width * totalScale,
            height: imageSize.height * totalScale
        )

        // Crop枠左上の「表示座標」
        let cropOriginX =
            (displayedSize.width - cropSize) / 2
            - offset.width

        let cropOriginY =
            (displayedSize.height - cropSize) / 2
            - offset.height

        // 画像座標へ変換
        let rect = CGRect(
            x: cropOriginX / totalScale,
            y: cropOriginY / totalScale,
            width: cropSize / totalScale,
            height: cropSize / totalScale
        )

        guard let croppedCG = cgImage.cropping(to: rect) else {
            return self
        }

        return UIImage(cgImage: croppedCG)
    }
}


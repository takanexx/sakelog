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
    let cropSizeW: CGFloat = 280
    let cropSizeH: CGFloat = 200

    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var gestureScale: CGFloat = 1.0
    @State private var gestureOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // 背景層：前面層と同じフレーム基準で scaledToFill し、clipped なしでフルスクリーンに溢れさせる
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .scaleEffect(scale * gestureScale)
                .offset(
                    x: offset.width + gestureOffset.width,
                    y: offset.height + gestureOffset.height
                )
                .frame(width: cropSizeW, height: cropSizeH)
                .opacity(0.4)
                .allowsHitTesting(false)

            // 前面層：クロップ枠サイズで固定 → cropped() の計算基準を維持
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .scaleEffect(scale * gestureScale)
                .offset(
                    x: offset.width + gestureOffset.width,
                    y: offset.height + gestureOffset.height
                )
                .frame(width: cropSizeW, height: cropSizeH)
                .clipped()
                .gesture(dragGesture)
                .gesture(magnificationGesture)

            // クロップ枠の枠線
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: cropSizeW, height: cropSizeH)
                .allowsHitTesting(false)

            // ボタン
            VStack {
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
                            cropSizeW: cropSizeW,
                            cropSizeH: cropSizeH,
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
    // 画像の向きを正規化
    func normalized() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? self
    }
    
    // 画像をクロップ
    func cropped(
        scale: CGFloat,
        offset: CGSize,
        cropSizeW: CGFloat,
        cropSizeH: CGFloat
    ) -> UIImage {

        guard let cgImage else { return self }

        let imageSize = CGSize(
            width: cgImage.width,
            height: cgImage.height
        )

        // scaledToFill の基準スケール
        let baseScale = max(
            cropSizeW / imageSize.width,
            cropSizeH / imageSize.height
        )

        let totalScale = baseScale * scale

        // 表示されている画像サイズ
        let displayedSize = CGSize(
            width: imageSize.width * totalScale,
            height: imageSize.height * totalScale
        )

        // Crop枠左上の「表示座標」
        let cropOriginX =
            (displayedSize.width - cropSizeW) / 2
            - offset.width

        let cropOriginY =
            (displayedSize.height - cropSizeH) / 2
            - offset.height

        // 画像座標へ変換
        let rect = CGRect(
            x: cropOriginX / totalScale,
            y: cropOriginY / totalScale,
            width: cropSizeW / totalScale,
            height: cropSizeH / totalScale
        )

        guard let croppedCG = cgImage.cropping(to: rect) else {
            return self
        }

        return UIImage(cgImage: croppedCG)
    }
}


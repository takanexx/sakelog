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

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(scale)
                        .offset(offset)
                        .frame(width: cropSize, height: cropSize)
                        .clipped()
                        .gesture(dragGesture.simultaneously(with: magnificationGesture))

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
                            viewSize: CGSize(width: cropSize, height: cropSize)
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
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }

    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = lastScale * value
            }
            .onEnded { _ in
                lastScale = scale
            }
    }
}


// UIImage トリミング用 Extension
extension UIImage {
    func cropped(
        scale: CGFloat,
        offset: CGSize,
        cropSize: CGFloat,
        viewSize: CGSize
    ) -> UIImage {

        let imageSize = size

        let scaleRatio = imageSize.width / viewSize.width

        let x = (-offset.width * scaleRatio) / scale
        let y = (-offset.height * scaleRatio) / scale
        let length = cropSize * scaleRatio / scale

        let cropRect = CGRect(x: x, y: y, width: length, height: length)

        guard let cgImage = cgImage?.cropping(to: cropRect) else {
            return self
        }
        return UIImage(cgImage: cgImage)
    }
}

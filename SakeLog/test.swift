//
//  JapanHeatMapView.swift
//  SakeLog
//
//  Created by Takane on 2025/11/25.
//

import SwiftUI
import SVGKit

struct test: View {
    @State private var data: [String: Double] = [  // 都道府県名 → 数値
        "Tokyo": 0.8,
        "Osaka": 0.6,
        "Hokkaido": 0.3,
        "Okinawa": 0.9
    ]

    var body: some View {
#if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            Text("SVG Preview Disabled in Xcode Preview")
                .foregroundColor(.gray)
        } else {
                SVGView(named: "jp") { layerName in
                    // SVG内レイヤー名が都道府県になっている必要あり
                    if let value = data[layerName] {
                        Color(hue: 0.3 - value * 0.3,
                              saturation: 1,
                              brightness: 1)
                    } else {
                        Color.gray.opacity(0.3)
                    }
                }
        }
#else
        SVGView(named: "jp") { layerName in
            // SVG内レイヤー名が都道府県になっている必要あり
            if let value = data[layerName] {
                Color(hue: 0.3 - value * 0.3,
                      saturation: 1,
                      brightness: 1)
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .frame(width: 300, height: 400)
        .padding()
#endif
    }
}


//
//  SVGView.swift
//
struct SVGView: UIViewRepresentable {
    let named: String
    var colorProvider: ((String) -> Color)? = nil

    func makeUIView(context: Context) -> SVGKLayeredImageView {
        guard let svgImage = SVGKImage(named: named) else {
            return SVGKLayeredImageView(svgkImage: SVGKImage(named: "jp")!)
        }
        return SVGKLayeredImageView(svgkImage: svgImage)
    }

    func updateUIView(_ uiView: SVGKLayeredImageView, context: Context) {
        if let colorProvider = colorProvider,
           let layers = uiView.layer.sublayers {
            for layer in layers {
                if let name = layer.name,
                   let shapeLayer = layer as? CAShapeLayer {
                    let uiColor = UIColor(colorProvider(name))
                    shapeLayer.fillColor = uiColor.cgColor     // ← CAShapeLayer ならOK
                }
            }
        }
    }
}



//
//  JapanHeatMapView.swift
//  SakeLog
//
//  Created by Takane on 2025/11/25.
//

import SwiftUI
import Macaw

struct JapanHeatMapView: View {
    @State private var data: [String: Double] = [
        "Tokyo": 0.8,
        "Osaka": 0.6,
        "Hokkaido": 0.3,
        "Okinawa": 0.9
    ]

    var body: some View {
        GeometryReader { geo in
            MacawSVGView(named: "jp", data: data, viewSize: geo.size)
        }
        .ignoresSafeArea()   // ← 画面いっぱいに使う
    }
}


struct MacawSVGView: UIViewRepresentable {
    let named: String
    let data: [String: Double]
    let viewSize: CGSize

    func makeUIView(context: Context) -> MacawView {
        let node = try! SVGParser.parse(resource: named)
        applyColors(to: node)

        let view = MacawView(node: node, frame: CGRect(origin: .zero, size: viewSize))
        view.backgroundColor = .clear

        // **レイアウト後に縮尺計算を行う**
        DispatchQueue.main.async {
//            fitToView(node: node, view: view)
            self.resizeAndCenter(node, size: viewSize)

        }
        
        return view
    }

    func updateUIView(_ uiView: MacawView, context: Context) {
        if let group = uiView.node as? Macaw.Group {
            applyColors(to: group)
//            fitToView(node: group, view: uiView)   // ← 更新時にも実行
            resizeAndCenter(group, size: viewSize) // 更新時も実行

        }
    }
    
    private func resizeAndCenter(_ node: Node, size viewSize: CGSize) {
        guard let group = node as? Macaw.Group else { return }

        // --- ① Shape の bounds を全部統合して正しい地図範囲を作る ---
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = CGFloat.leastNormalMagnitude
        var maxY = CGFloat.leastNormalMagnitude

        func collectBounds(_ n: Node) {
            if let shape = n as? Macaw.Shape, let b = shape.bounds {
                minX = min(minX, CGFloat(b.x))
                minY = min(minY, CGFloat(b.y))
                maxX = max(maxX, CGFloat(b.x + b.w))
                maxY = max(maxY, CGFloat(b.y + b.h))
            }

            if let g = n as? Macaw.Group {
                for child in g.contents {
                    collectBounds(child)
                }
            }
        }

        collectBounds(group)

        // SVG 実サイズ
        let svgWidth  = maxX - minX
        let svgHeight = maxY - minY
        if svgWidth <= 0 || svgHeight <= 0 { return }

        // --- ② 画面にフィットするスケール ---
        let scale = min(viewSize.width / svgWidth,
                        viewSize.height / svgHeight)

        // スケール後の大きさ
        let scaledW = svgWidth * scale
        let scaledH = svgHeight * scale

        // --- ③ 中央寄せ ---
        let offsetX = (viewSize.width  - scaledW) / 2
        let offsetY = (viewSize.height - scaledH) / 2

        // --- ④ Transform の順番が超重要 ---
        group.place =
            Transform.move(dx: -minX, dy: -minY) // ① 正しい原点に移動
                .scale(sx: scale, sy: scale)     // ② スケール
                .move(dx: offsetX, dy: offsetY)  // ③ 中央へ
    }

    

    /// SVG内レイヤー名に応じて色を設定
    private func applyColors(to node: Macaw.Node) {
        if let group = node as? Macaw.Group {
            for child in group.contents {
                applyColors(to: child)
            }
        } else if let shape = node as? Macaw.Shape {
            let layerNames = shape.tag  // ← Optionalでないので for で回す
            for layerName in layerNames {
                let value = data[layerName] ?? 0
                shape.fill = Macaw.Color.rgb(
                    r: 255 * (1 - Int(value)),
                    g: 255 * Int(value),
                    b: 100
                )
                
                // 境界線を設定
                shape.stroke = Stroke(
                    fill: Macaw.Color.white,  // 線の色
                    width: 1.0                // 線の太さ
                )
            }
        }
    }
}

#Preview {
    JapanHeatMapView()
}

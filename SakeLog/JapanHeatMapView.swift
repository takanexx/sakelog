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
            self.resizeAndCenter(node: node, size: viewSize)

        }
        
        return view
    }

    func updateUIView(_ uiView: MacawView, context: Context) {
        if let group = uiView.node as? Macaw.Group {
            applyColors(to: group)
//            fitToView(node: group, view: uiView)   // ← 更新時にも実行
            resizeAndCenter(node: group, size: viewSize) // 更新時も実行

        }
    }
    
    private func resizeAndCenter(node: Macaw.Node, size viewSize: CGSize) {
        guard let group = node as? Macaw.Group else { return }
        guard let bounds = group.bounds else { return }   // ← Optional をアンラップ

        // 正しい SVG サイズを取得
        let svgSize = bounds.size()

        guard svgSize.w > 0, svgSize.h > 0 else { return }

        let scaleX = viewSize.width / svgSize.w
        let scaleY = viewSize.height / svgSize.h
        let scale = min(scaleX, scaleY)

        // 中央寄せ
        let offsetX = (viewSize.width  - svgSize.w * scale) / 2
        let offsetY = (viewSize.height - svgSize.h * scale) / 2

        group.place = Transform.move(dx: offsetX, dy: offsetY)
            .scale(sx: scale, sy: scale)
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

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
                .frame(width: geo.size.width, height: geo.size.height)
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

        node.place = Transform.scale(sx: 0.5, sy: 0.5) // 50%に縮小
        let view = MacawView(node: node, frame: CGRect(origin: .zero, size: viewSize))
        view.backgroundColor = .clear
        
        return view
    }

    func updateUIView(_ uiView: MacawView, context: Context) {
        if let group = uiView.node as? Macaw.Group {
            applyColors(to: group)
        }
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


import SwiftUI
import SwiftSVG

// UIViewController を SwiftUI にラップ
struct JapanMapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        
        guard let svgURL = Bundle.main.url(forResource: "jp", withExtension: "svg") else {
            print("jp.svg が見つかりません")
            return container
        }
        
        // SVGをCALayerとして読み込み
        let _ = CALayer(SVGURL: svgURL) { layer in
            let targetWidth = UIScreen.main.bounds.width * 0.7
            let boundingBox = layer.boundingBox
            let scale = targetWidth / boundingBox.width
            layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
            
            // 中央配置
            layer.position = CGPoint(x: container.bounds.midX * 0.7,
                                     y: container.bounds.midY * 0.7)
            
            container.layer.addSublayer(layer)
        }
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // 画面回転やサイズ変更対応もここで可能
    }
}

// プレビュー
struct JapanMapView_Previews: PreviewProvider {
    static var previews: some View {
        JapanMapView()
//            .frame(width: 300, height: 400) // プレビュー用にサイズを指定
            .background(Color.gray.opacity(0.2))
    }
}


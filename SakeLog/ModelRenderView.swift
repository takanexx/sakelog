//
//  Cabinet.swift
//  SakeLog
//
//  Created by Takane on 2025/10/06.
//

import SwiftUI
import SceneKit

struct ModelRenderView: UIViewRepresentable {
    let labelImageName: String?
    let allowsCameraControl: Bool? // カメラ操作の有効化

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = allowsCameraControl ?? true
        view.autoenablesDefaultLighting = true
        view.backgroundColor = .clear
        view.defaultCameraController.interactionMode = .orbitTurntable  // ピンチ回転も自然に




        DispatchQueue.global(qos: .userInitiated).async {
            if let scene = self.loadScene() {
                DispatchQueue.main.async {
                    view.scene = scene
                    self.fitModelToView(scene: scene, view: view) // ← ここで自動フィット！
                }
                // 👇 自動回転を追加
                if let root = scene.rootNode.childNodes.first {
                    let spin = SCNAction.repeatForever(
                        SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Double.pi * 2), duration: 10)
                    )
                    root.runAction(spin)
                }
            } else {
                print("⚠️ Failed to load Scene")
            }
        }

        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}

    private func loadScene() -> SCNScene? {
        // GLBファイルを探す
        guard let url = Bundle.main.url(forResource: "template", withExtension: "usdc") else {
            print("❌ model not found in bundle")
            return nil
        }

        // GLBはSceneKitで未完全対応 → iOS実機で試すかUSDZに変換
        guard let sceneSource = SCNSceneSource(url: url, options: nil),
              let scene = sceneSource.scene(options: nil) else {
            print("⚠️ Could not load GLB. Try converting to USDZ or test on device.")
            return nil
        }

        // カメラ追加
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, -5, 1)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(cameraNode)
        
        // MARK: - ラベル差し替え（アプリ内保存画像対応）
        if let labelImageName {
            let url = getDocumentsDirectory().appendingPathComponent(labelImageName)
            print(url)
            if FileManager.default.fileExists(atPath: url.path),
               let image = UIImage(contentsOfFile: url.path) {
                replaceLabelMaterial(in: scene.rootNode, with: image)
                print("✅ Loaded label image from Documents:", url.lastPathComponent)
            } else if let fallbackImage = UIImage(named: labelImageName) {
                // フォールバックとしてBundle内も探す
                replaceLabelMaterial(in: scene.rootNode, with: fallbackImage)
                print("⚠️ Used fallback image from Bundle:", labelImageName)
            } else {
                print("❌ Label image not found:", labelImageName)
            }
        }

        return scene
    }

    // ラベルに画像をセット
    private func replaceLabelMaterial(in node: SCNNode, with image: UIImage) {
        for child in node.childNodes {
            replaceLabelMaterial(in: child, with: image)
        }

        if let geometry = node.geometry {
            for (i, material) in geometry.materials.enumerated() {
                if material.name == "LabelMaterial" {
                    let newMat = SCNMaterial()
                    newMat.diffuse.contents = image
                    newMat.isDoubleSided = true
                    
                    // ✅ アスペクト比に合わせてスケーリング
                    let aspect = Float(image.size.width / image.size.height)
                    let scale: Float = 0.2 // 好みの縮小率（例：0.6 = 60%サイズ）

                    var transform = SCNMatrix4Identity
                    
                    // ⚙️ アスペクト比を保ちつつ縦横比スケール
                    // UV空間(0〜1)に対してスケールを設定
                    transform = SCNMatrix4Scale(transform, aspect * scale, scale, 0.1)

                    // ⚙️ テクスチャを中心寄せ
                    transform = SCNMatrix4Translate(transform, (1 - 1 / (aspect)) * 0.2, 0.2, 0.0)

                    // ✅ SceneKitの座標はY軸反転なのでここで反転
                    transform = SCNMatrix4Translate(transform, 0.0, 1.0, 0.0)
                    transform = SCNMatrix4Scale(transform, 1.0, -1.0, 1.0)

                    newMat.diffuse.contentsTransform = transform
                    newMat.emission.contents = image

                    geometry.replaceMaterial(at: i, with: newMat)
                    print("✅ LabelMaterial replaced")
                }
            }
        }
    }
    // MARK: - モデルを画面いっぱいにフィット
    private func fitModelToView(scene: SCNScene, view: SCNView) {
        guard let node = scene.rootNode.childNodes.first else { return }

        // バウンディングボックスからサイズと中心を取得
        let (minVec, maxVec) = node.boundingBox
        let size = SCNVector3(
            x: maxVec.x - minVec.x,
            y: maxVec.y - minVec.y,
            z: maxVec.z - minVec.z
        )
        let center = SCNVector3(
            x: (minVec.x + maxVec.x) / 2,
            y: (minVec.y + maxVec.y) / 2,
            z: (minVec.z + maxVec.z) / 2
        )

        // 原点に移動
        node.position = SCNVector3(-center.x, -center.y, -center.z)

        // サイズに基づいてスケール調整（画面いっぱい）
        let maxDimension = max(size.x, size.y, size.z)
        if maxDimension > 0 {
            let scaleFactor = 3.0 / maxDimension // 調整係数（好みで変更）
            node.scale = SCNVector3(x: scaleFactor, y: scaleFactor, z: scaleFactor)
        }

        // カメラコントローラ設定
        if let cameraNode = scene.rootNode.childNodes.first(where: { $0.camera != nil }) {
            view.pointOfView = cameraNode
            view.defaultCameraController.pointOfView = cameraNode // ← ✅ ここが修正ポイント
            view.defaultCameraController.target = SCNVector3Zero
        }

    }
}

extension UIImage {

    /// 最大辺を maxSize に収めてアスペクト比維持で縮小
    func resized(maxSize: CGFloat) -> UIImage {
        let maxSide = max(size.width, size.height)

        // 縮小不要
        if maxSide <= maxSize {
            return self
        }

        let scale = maxSize / maxSide
        let newSize = CGSize(
            width: size.width * scale,
            height: size.height * scale
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

#Preview {
    ModelRenderView(labelImageName: "izumi", allowsCameraControl: true)
}


import { Asset } from "expo-asset";
import { GLView } from "expo-gl";
import { Renderer, THREE } from "expo-three";
import React, { useRef } from "react";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

export default function ModelRenderView({ fileName }: { fileName?: string }) {
  const modelRef = useRef<THREE.Object3D | null>(null);

  const loadModel = async (scene: THREE.Scene) => {
    // house.glb を assets から取得
    // const file = fileName ?? "zaku.glb";
    const file = "template.glb";
    const asset = Asset.fromModule(require(`../assets/models/${file}`));
    await asset.downloadAsync();

    return new Promise<THREE.Object3D>((resolve, reject) => {
      const loader = new GLTFLoader();
      loader.load(
        asset.localUri || asset.uri,
        (gltf) => {
          const model = gltf.scene;

          // バウンディングボックスでサイズを調べる
          const box = new THREE.Box3().setFromObject(model);
          const size = new THREE.Vector3();
          box.getSize(size);
          const center = new THREE.Vector3();
          box.getCenter(center);

          // モデルを中心に移動させる
          model.position.sub(center);
          scene.add(model);

          resolve(model);
        },
        undefined,
        (error) => {
          console.error("GLTF load error:", error);
          reject(error);
        }
      );
    });
  };

  return (
    <GLView
      style={{ width: "100%", height: "80%" }}
      onContextCreate={async (gl) => {
        const width = gl.drawingBufferWidth;
        const height = gl.drawingBufferHeight;

        const renderer = new Renderer({ gl, width, height });
        renderer.setSize(width, height);

        const scene = new THREE.Scene();
        scene.background = new THREE.Color("white");

        const camera = new THREE.PerspectiveCamera(
          75,
          width / height,
          0.1,
          1000
        );
        camera.position.set(0, 2, 5); // Yを少し上げて、Zを引く
        camera.lookAt(0, 0, 0);

        // 環境光と方向光
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
        scene.add(ambientLight);

        const dirLight = new THREE.DirectionalLight(0xffffff, 0.8);
        dirLight.position.set(5, 10, 5);
        scene.add(dirLight);

        // house.glb をロード
        const model = await loadModel(scene);
        modelRef.current = model;

        // スケール調整（大きい場合は小さくする）
        model.scale.set(1.5, 1.5, 1.5);

        // デバッグ: バウンディングボックスを可視化
        const boxHelper = new THREE.BoxHelper(model, 0xff0000);
        scene.add(boxHelper);

        // アニメーションループ
        const clock = new THREE.Clock();
        const animate = () => {
          requestAnimationFrame(animate);

          const delta = clock.getDelta();

          if (modelRef.current) {
            modelRef.current.rotation.y += delta * 0.5;
          }

          renderer.render(scene, camera);
          gl.endFrameEXP();
        };
        animate();
      }}
    />
  );
}

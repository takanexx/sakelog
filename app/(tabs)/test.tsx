import { Asset } from "expo-asset";
import { GLView } from "expo-gl";
import { Renderer } from "expo-three";
import { useRef } from "react";
import { Dimensions, SafeAreaView, StyleSheet } from "react-native";
import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";

export default function TestScreen() {
  const modelRef = useRef<THREE.Object3D | null>(null);

  const loadModel = async (scene: THREE.Scene) => {
    // house.glb を assets から取得
    const asset = Asset.fromModule(require("../../assets/models/zaku.glb"));
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

          console.log("Model size:", size);
          console.log("Model center:", center);
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
    <SafeAreaView style={{ flex: 1 }}>
      {/* 上部タイトル */}
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">test</ThemedText>
      </ThemedView>

      <ThemedView
        style={{
          width: Dimensions.get("window").width - 20,
          height: 500,
          marginHorizontal: 4,
          justifyContent: "center",
          alignItems: "center",
          shadowColor: "#000",
          shadowOffset: { width: 0, height: 2 },
          shadowOpacity: 0.2,
          shadowRadius: 4,
          elevation: 5,
          borderRadius: 10,
          borderBlockColor: "gray",
          padding: 8,
        }}
      >
        <GLView
          style={{ width: "100%", height: "100%", backgroundColor: "pink" }}
          onContextCreate={async (gl) => {
            const width = gl.drawingBufferWidth;
            const height = gl.drawingBufferHeight;

            const renderer = new Renderer({ gl, width, height });
            renderer.setSize(width, height);

            const scene = new THREE.Scene();
            scene.background = new THREE.Color(0xf0f0f0);

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
            // model.scale.set(0.5, 0.5, 0.5);

            // デバッグ: バウンディングボックスを可視化
            const boxHelper = new THREE.BoxHelper(model, 0xff0000);
            scene.add(boxHelper);

            // アニメーションループ
            const animate = () => {
              requestAnimationFrame(animate);

              if (modelRef.current) {
                modelRef.current.rotation.y += 0.1;
              }

              renderer.render(scene, camera);
              gl.endFrameEXP();
            };
            animate();
          }}
        />
      </ThemedView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    padding: 20,
    backgroundColor: "transparent",
  },
});

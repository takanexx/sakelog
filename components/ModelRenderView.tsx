import { Asset } from "expo-asset";
import { GLView } from "expo-gl";
import { loadAsync, Renderer, THREE } from "expo-three";
import React, { useRef } from "react";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

export default function ModelRenderView() {
  const modelRef = useRef<THREE.Object3D | null>(null);

  const loadModel = async (scene: THREE.Scene) => {
    // 1️⃣ モデルの読み込み
    const modelAsset = Asset.fromModule(
      require("../assets/models/template.glb")
    );
    await modelAsset.downloadAsync();

    const loader = new GLTFLoader();
    const gltf = await new Promise<THREE.GLTF>((resolve, reject) => {
      loader.load(modelAsset.localUri || "", resolve, undefined, reject);
    });

    const model = gltf.scene;
    model.scale.set(1.5, 1.5, 1.5);
    scene.add(model);
    modelRef.current = model;

    // 2️⃣ ラベルテクスチャの読み込み（事前に await）
    const labelTexture = await loadAsync(require("../assets/labels/izumi.jpg"));

    // 3️⃣ traverse でマテリアルを差し替え
    model.traverse((child: any) => {
      if (child.isMesh && child.material?.name === "LabelMaterial") {
        // 元の material を差し替えるのが安全
        child.material = new THREE.MeshBasicMaterial({
          map: labelTexture,
          transparent: true,
          side: THREE.DoubleSide,
        });
        child.material.needsUpdate = true;
      }
    });
  };

  const onContextCreate = async (gl: any) => {
    const { drawingBufferWidth: width, drawingBufferHeight: height } = gl;

    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
    camera.position.z = 5;

    const renderer = new Renderer({ gl });
    renderer.setSize(width, height);

    const light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5, 10, 5).normalize();
    scene.add(light);

    await loadModel(scene);

    const render = () => {
      requestAnimationFrame(render);
      renderer.render(scene, camera);
      gl.endFrameEXP();
    };
    render();
  };

  return (
    <GLView
      style={{ width: "100%", height: "80%" }}
      onContextCreate={onContextCreate}
    />
  );
}

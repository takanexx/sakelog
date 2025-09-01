import { Asset } from "expo-asset";
import { GLView } from "expo-gl";
import { Renderer, THREE } from "expo-three";
import React, { useRef } from "react";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

export default function ModelRenderView({ fileName }: { fileName?: string }) {
  const modelRef = useRef<THREE.Object3D | null>(null);

  const loadModel = async (scene: THREE.Scene) => {
    // モデルの読み込み
    const modelAsset = Asset.fromModule(
      require("../assets/models/template.glb")
    );
    await modelAsset.downloadAsync();

    const loader = new GLTFLoader();
    const gltf = await new Promise<THREE.GLTF>((resolve, reject) => {
      loader.load(modelAsset.localUri || "", resolve, undefined, reject);
    });

    const model = gltf.scene;
    scene.add(model);
    modelRef.current = model;

    // ラベル画像の読み込み
    const labelTexture = new THREE.TextureLoader().load(
      // Asset.fromModule(require("../assets/labels/test.png")).uri
      Asset.fromModule(require("../assets/labels/izumi.jpg")).uri
    );

    // スケール調整（大きい場合は小さくする）
    model.scale.set(1.5, 1.5, 1.5);

    // "LabelMaterial" を探してテクスチャを適用
    model.traverse((child: any) => {
      if (
        child.isMesh &&
        child.material &&
        child.material.name === "LabelMaterial"
      ) {
        console.log("Found LabelMaterial, applying texture");

        if (child.geometry.attributes.uv) {
          console.log("✅ UV展開されています");
        } else {
          console.log("❌ UV展開されていません");
        }

        child.material.map = labelTexture;
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

    // const animate = () => {
    //   requestAnimationFrame(animate);
    //   if (modelRef.current) {
    //     modelRef.current.rotation.y += 0.01;
    //   }
    //   renderer.render(scene, camera);
    //   gl.endFrameEXP();
    // };
    // animate();
  };

  return (
    <GLView
      style={{ width: "100%", height: "80%" }}
      onContextCreate={async (gl) => {
        await onContextCreate(gl);
      }}
    />
  );
}

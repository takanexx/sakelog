import { GLView } from "expo-gl";
import { Renderer } from "expo-three";
import { useRef } from "react";
import { Dimensions, FlatList, SafeAreaView, StyleSheet } from "react-native";
import * as THREE from "three";

import FloatingActionButton from "@/components/FloatingActionButton";
import { HelloWave } from "@/components/HelloWave";
import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";

export default function CabinetScreen() {
  const modelRef = useRef<THREE.Object3D | null>(null);
  const numColumns = 3;
  const { width } = Dimensions.get("window");

  const horizontalPadding = 20;
  const gap = 6;
  const margin = 4;

  const cardSize =
    (width - horizontalPadding - gap * (numColumns - 1) - margin * numColumns) /
    numColumns;

  return (
    <SafeAreaView style={{ flex: 1 }}>
      {/* 上部タイトル */}
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">Search</ThemedText>
        <HelloWave />
      </ThemedView>
      <FlatList
        numColumns={numColumns}
        showsVerticalScrollIndicator={false}
        showsHorizontalScrollIndicator={false}
        data={[...Array(21).keys()].map((i) => `Item ${i + 1}`)}
        horizontal={false}
        keyExtractor={(item, index) => index.toString()}
        contentContainerStyle={{
          paddingHorizontal: 10,
          gap: 6,
          paddingBottom: 100,
        }}
        renderItem={({ item }) => (
          <ThemedView
            style={{
              width: cardSize,
              height: cardSize * 1.5,
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
              style={{ width: "100%", height: "100%" }}
              onContextCreate={(gl) => {
                const width = gl.drawingBufferWidth || 300;
                const height = gl.drawingBufferHeight || 300;

                const renderer = new Renderer({ gl, width, height });
                const scene = new THREE.Scene();
                scene.background = new THREE.Color(0xf0f0f0);

                const camera = new THREE.PerspectiveCamera(
                  75,
                  width / height,
                  0.1,
                  1000
                );
                camera.position.set(0, 0, 5);
                camera.lookAt(0, 0, 0);

                const light = new THREE.AmbientLight(0xffffff, 1.2);
                scene.add(light);

                const geometry = new THREE.BoxGeometry(1, 1, 1);
                const material = new THREE.MeshStandardMaterial({
                  color: 0xff0000,
                });
                const cube = new THREE.Mesh(geometry, material);
                scene.add(cube);

                const animate = () => {
                  requestAnimationFrame(animate);
                  cube.rotation.y += 0.01;
                  renderer.render(scene, camera);
                  gl.endFrameEXP();
                };
                animate();
              }}
            />
          </ThemedView>
        )}
      />
      <FloatingActionButton />
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

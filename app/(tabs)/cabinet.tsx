import { Dimensions, FlatList, SafeAreaView, StyleSheet } from "react-native";

import AddSakeModal from "@/components/AddSakeModal";
import FloatingActionButton from "@/components/FloatingActionButton";
import { HelloWave } from "@/components/HelloWave";
import ModelRenderView from "@/components/ModelRenderView";
import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";
import { useState } from "react";

export default function CabinetScreen() {
  const [modalVisible, setModalVisible] = useState(false);

  const numColumns = 2;
  const { width } = Dimensions.get("window");

  const horizontalPadding = 23;
  const gap = 6;
  const margin = 6;

  const cardSize =
    (width - horizontalPadding - gap * (numColumns - 1) - margin * numColumns) /
    numColumns;

  return (
    <>
      <SafeAreaView style={{ flex: 1 }}>
        {/* 上部タイトル */}
        <ThemedView style={styles.titleContainer}>
          <ThemedText type="title">Cabinet</ThemedText>
          <HelloWave />
        </ThemedView>
        {/* リスト */}
        <FlatList
          numColumns={numColumns}
          showsVerticalScrollIndicator={false}
          showsHorizontalScrollIndicator={false}
          data={[...Array(6).keys()].map((i) => `Item ${i + 1}`)}
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
                margin: 6,
                justifyContent: "center",
                alignItems: "center",
                shadowColor: "#000",
                shadowOffset: { width: 0, height: 2 },
                shadowOpacity: 0.2,
                shadowRadius: 4,
                elevation: 5,
                borderRadius: 20,
                padding: 8,
              }}
            >
              <ModelRenderView />
              <ThemedText style={{ marginTop: 8 }}>Sake Name</ThemedText>
            </ThemedView>
          )}
        />
        <FloatingActionButton onPressFunction={() => setModalVisible(true)} />
      </SafeAreaView>
      <AddSakeModal
        visible={modalVisible}
        onClose={() => setModalVisible(false)}
      />
    </>
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

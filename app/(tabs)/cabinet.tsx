import {
  Dimensions,
  FlatList,
  Modal,
  SafeAreaView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

import FloatingActionButton from "@/components/FloatingActionButton";
import { HelloWave } from "@/components/HelloWave";
import ModelRenderView from "@/components/ModelRenderView";
import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";
import { Colors } from "@/constants/Colors";
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
      <Modal
        animationType="slide"
        visible={modalVisible}
        presentationStyle="pageSheet"
        onRequestClose={() => setModalVisible(false)}
      >
        <ThemedView
          style={{
            flex: 1,
            alignItems: "center",
            paddingTop: 30,
            paddingHorizontal: 20,
          }}
        >
          <ThemedText type="title">Model Viewer</ThemedText>
          <View
            style={{
              marginTop: 20,
              gap: 8,
              width: "100%",
            }}
          >
            <ThemedText style={{ fontWeight: "bold" }}>Sake Name</ThemedText>
            <TextInput
              style={{
                width: "100%",
                height: 40,
                borderColor: Colors.light.tint,
                borderWidth: 1,
                borderRadius: 10,
                paddingHorizontal: 10,
              }}
              placeholder="Input Sake Name..."
            />
          </View>

          <View
            style={{
              marginTop: 20,
              gap: 8,
              width: "100%",
            }}
          >
            <ThemedText style={{ fontWeight: "bold" }}>Memo</ThemedText>
            <TextInput
              multiline
              numberOfLines={4}
              style={{
                width: "100%",
                height: 100,
                borderColor: Colors.light.tint,
                borderWidth: 1,
                borderRadius: 10,
                paddingHorizontal: 10,
                textAlignVertical: "top",
              }}
              placeholder="Input Memo..."
            />
          </View>
          <View style={{ marginTop: 40, width: "100%" }}>
            <TouchableOpacity
              style={{
                backgroundColor: Colors.light.tint,
                paddingVertical: 10,
                borderRadius: 10,
                alignItems: "center",
              }}
            >
              <Text style={{ fontWeight: "bold", color: Colors.dark.text }}>
                Save
              </Text>
            </TouchableOpacity>
          </View>
        </ThemedView>
      </Modal>
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

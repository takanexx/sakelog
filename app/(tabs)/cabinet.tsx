import FloatingActionButton from "@/components/FloatingActionButton";
import { HelloWave } from "@/components/HelloWave";
import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";
import { Dimensions, FlatList, SafeAreaView, StyleSheet } from "react-native";

export default function CabinetScreen() {
  const numColumns = 3;
  const { width } = Dimensions.get("window");

  // FlatList の contentContainerStyle とカード margin に合わせる
  const horizontalPadding = 20; // 左右合計 (paddingHorizontal:10 * 2)
  const gap = 6; // gap
  const margin = 4; // カード左右のmarginHorizontal合計 (4+4)

  const cardSize =
    (width - horizontalPadding - gap * (numColumns - 1) - margin * numColumns) /
    numColumns;

  return (
    <>
      <SafeAreaView>
        <ThemedView style={styles.titleContainer}>
          <ThemedText type="title">Search</ThemedText>
          <HelloWave />
        </ThemedView>
      </SafeAreaView>

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
            <ThemedText>{item}. Add your favorite sake</ThemedText>
          </ThemedView>
        )}
      />

      <FloatingActionButton />
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
  stepContainer: {
    padding: 20,
    backgroundColor: "transparent",
  },
  reactLogo: {
    width: 100,
    height: 100,
    alignSelf: "center",
    marginBottom: 20,
  },
});

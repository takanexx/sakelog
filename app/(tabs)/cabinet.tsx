import FloatingActionButton from "@/components/FloatingActionButton";
import { HelloWave } from "@/components/HelloWave";
import ParallaxScrollView from "@/components/ParallaxScrollView";
import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";
import { Image } from "expo-image";
import { StyleSheet } from "react-native";

export default function CabinetScreen() {
  return (
    <>
      <ParallaxScrollView
        headerBackgroundColor={{ light: "#A1CEDC", dark: "#1D3D47" }}
        headerImage={
          <Image
            source={require("@/assets/images/partial-react-logo.png")}
            style={styles.reactLogo}
          />
        }
      >
        <ThemedView style={styles.titleContainer}>
          <ThemedText type="title">Search</ThemedText>
          <HelloWave />
        </ThemedView>
        <ThemedView style={styles.stepContainer}>
          <ThemedText type="subtitle">Search Feature</ThemedText>
          <ThemedText>
            This is a placeholder for the search feature. Implement your search
            logic here.
          </ThemedText>
        </ThemedView>
      </ParallaxScrollView>
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

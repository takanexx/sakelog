import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";
import { useRouter } from "expo-router";
import {
  SafeAreaView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

export default function SettingScreen() {
  const router = useRouter();

  return (
    <SafeAreaView>
      <ThemedView style={styles.card}>
        <Text>hoge</Text>
      </ThemedView>
      <ThemedView style={styles.card}>
        <View style={{ ...styles.row, paddingTop: 0 }}>
          <Text>テーマ</Text>
          <Text style={{ fontWeight: "bold" }}>ダーク</Text>
        </View>
        <View style={styles.row}>
          <Text>テーマ</Text>
          <Text style={{ fontWeight: "bold" }}>ダーク</Text>
        </View>
        <View style={{ ...styles.row, borderBottomWidth: 0, paddingBottom: 0 }}>
          <Text>テーマ</Text>
          <Text style={{ fontWeight: "bold" }}>ダーク</Text>
        </View>
      </ThemedView>
      <ThemedView style={styles.card}>
        <TouchableOpacity
          style={{ width: "100%" }}
          onPress={() => console.log("pressed")}
        >
          <Text style={{ color: "red" }}>アカウントを削除</Text>
        </TouchableOpacity>
      </ThemedView>
      <ThemedText
        style={{
          textAlign: "center",
          marginTop: 20,
          marginBottom: 50,
          color: "gray",
        }}
      >
        Version 1.0.0
      </ThemedText>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 10,
    padding: 15,
    marginHorizontal: 15,
    marginVertical: 10,
    marginTop: 20,
  },
  row: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    borderBlockColor: "lightgray",
    borderBottomWidth: 1,
    paddingVertical: 12,
  },
  sectionListItemView: {
    paddingHorizontal: 5,
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: "lightgray",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
});

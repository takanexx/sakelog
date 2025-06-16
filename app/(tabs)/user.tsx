import { Colors } from "@/constants/Colors";
import { Ionicons } from "@expo/vector-icons";
import { useRouter } from "expo-router";
import {
  Alert,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

export default function UserScreen() {
  const router = useRouter();

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <View style={{ justifyContent: "space-between", flexDirection: "row" }}>
        <Text style={{ padding: 5, fontWeight: "bold", color: "gray" }}>
          ユーザー
        </Text>
        <TouchableOpacity>
          <Ionicons
            name="create-outline"
            size={24}
            color={Colors.light.tint}
            style={{ padding: 5 }}
          />
        </TouchableOpacity>
      </View>
      <View
        style={{ ...styles.card, backgroundColor: Colors.light.background }}
      >
        <View
          style={{
            ...styles.sectionListItemView,
          }}
        >
          <Text style={{ fontSize: 16, color: Colors.light.text }}>
            ユーザー名
          </Text>
          <Text
            style={{
              fontSize: 16,
              fontWeight: "bold",
              color: Colors.light.text,
            }}
          >
            YouTube
          </Text>
        </View>
        <View style={{ ...styles.sectionListItemView, borderBottomWidth: 0 }}>
          <Text style={{ fontSize: 16, color: Colors.light.text }}>
            メールアドレス
          </Text>
          <Text
            style={{
              fontSize: 16,
              fontWeight: "bold",
              color: Colors.light.text,
            }}
          >
            あどれす
          </Text>
        </View>
      </View>

      <View style={{ marginTop: 40 }}>
        <TouchableOpacity
          onPress={() => {
            Alert.alert(
              "アカウントを削除しますか？",
              "ユーザーに紐づく全てのデータが削除されます。削除したデータを復元することはできません。",
              [
                {
                  text: "キャンセル",
                  style: "cancel",
                },
                {
                  text: "削除する",
                  style: "destructive",
                  onPress: () => {},
                },
              ]
            );
          }}
          style={{
            paddingHorizontal: 15,
            paddingVertical: 8,
            borderRadius: 10,
            borderColor: "red",
            borderWidth: 1,
            marginTop: 30,
          }}
        >
          <Text style={{ fontSize: 16, color: "red", textAlign: "center" }}>
            アカウントの削除
          </Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 20,
    paddingBottom: 100,
  },
  card: {
    backgroundColor: "white",
    borderRadius: 10,
    paddingHorizontal: 10,
  },
  cardTitle: {
    fontWeight: "bold",
    fontSize: 18,
    paddingHorizontal: 5,
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

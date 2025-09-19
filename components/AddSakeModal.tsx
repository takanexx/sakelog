import { Colors } from "@/constants/Colors";
import { Ionicons } from "@expo/vector-icons";
import { Image } from "expo-image";
import * as ImagePicker from "expo-image-picker";
import React, { useState } from "react";
import { Modal, TextInput, TouchableOpacity, View } from "react-native";
import { ThemedText } from "./ThemedText";
import { ThemedView } from "./ThemedView";

type AddSakeModalProps = {
  visible: boolean;
  onClose: () => void;
};

export default function AddSakeModal({ visible, onClose }: AddSakeModalProps) {
  const [image, setImage] = useState<string | null>(null);

  const pickImage = async () => {
    // No permissions request is necessary for launching the image library
    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ["images"],
      // allowsEditing: true,
      // aspect: [4, 3],
      quality: 1,
    });

    console.log(result);

    if (!result.canceled) {
      setImage(result.assets[0].uri);
    }
  };

  return (
    <Modal
      animationType="slide"
      visible={visible}
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <ThemedView
        style={{
          flex: 1,
          alignItems: "center",
          paddingTop: 20,
          paddingHorizontal: 20,
        }}
      >
        <Ionicons
          name="close-circle-outline"
          size={30}
          color={Colors.light.text}
          onPress={onClose}
          style={{ alignSelf: "flex-end" }}
        />

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

        <View style={{ marginTop: 20, gap: 8, width: "100%" }}>
          <ThemedText style={{ fontWeight: "bold" }}>Label</ThemedText>
          {image ? (
            <>
              <Image
                source={{ uri: image }}
                style={{
                  width: "80%",
                  height: 150,
                  borderRadius: 5,
                  alignSelf: "center",
                }}
                resizeMode="cover"
              />
              <Ionicons
                name="close-circle-outline"
                size={30}
                color={Colors.light.text}
                onPress={() => setImage(null)}
                style={{ position: "absolute", top: 10, right: 10 }}
              />
            </>
          ) : (
            <TouchableOpacity
              style={{
                marginTop: 10,
                alignItems: "center",
                justifyContent: "center",
                borderWidth: 1,
                borderColor: Colors.light.tint,
                borderRadius: 10,
                borderStyle: "dashed",
                height: 150,
              }}
              onPress={pickImage}
            >
              <ThemedText
                style={{ color: Colors.light.icon, marginBottom: 10 }}
              >
                Select Label Image
              </ThemedText>
              <Ionicons
                name="image-outline"
                size={50}
                color={Colors.light.icon}
              />
            </TouchableOpacity>
          )}
        </View>

        <View style={{ marginTop: 20, gap: 8, width: "100%" }}>
          <ThemedText style={{ fontWeight: "bold" }}>Rating</ThemedText>
          <TextInput
            style={{
              width: "100%",
              height: 40,
              borderColor: Colors.light.tint,
              borderWidth: 1,
              borderRadius: 10,
              paddingHorizontal: 10,
            }}
            placeholder="Input Rating..."
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
            <ThemedText style={{ fontWeight: "bold", color: Colors.dark.text }}>
              Save
            </ThemedText>
          </TouchableOpacity>
        </View>
      </ThemedView>
    </Modal>
  );
}

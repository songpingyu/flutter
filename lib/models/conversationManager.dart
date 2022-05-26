// To parse this JSON data, do
//
//     final conversationManager = conversationManagerFromJson(jsonString);

import 'dart:convert';

List<ConversationManager> conversationManagerFromJson(String str) =>
    List<ConversationManager>.from(
        json.decode(str).map((x) => ConversationManager.fromJson(x)));

String conversationManagerToJson(List<ConversationManager> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConversationManager {
  ConversationManager({
    this.recipientId,
    this.text,
    this.image,
  });

  String recipientId;
  String text;
  String image;

  factory ConversationManager.fromJson(Map<String, dynamic> json) =>
      ConversationManager(
        recipientId: json["recipient_id"],
        text: json["text"] == null ? null : json["text"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "recipient_id": recipientId,
        "text": text == null ? null : text,
        "image": image == null ? null : image,
      };
}

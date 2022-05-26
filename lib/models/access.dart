// To parse this JSON data, do
//
//     final newModel = newModelFromJson(jsonString);

import 'dart:convert';

NewModel newModelFromJson(String str) => NewModel.fromJson(json.decode(str));

String newModelToJson(NewModel data) => json.encode(data.toJson());

class NewModel {
  NewModel({
    this.accessToken,
  });

  String accessToken;

  factory NewModel.fromJson(Map<String, dynamic> json) => NewModel(
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
      };
}

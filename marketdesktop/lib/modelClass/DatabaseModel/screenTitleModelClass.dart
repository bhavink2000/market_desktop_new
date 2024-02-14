// To parse this JSON data, do
//
//     final screenTitleModel = screenTitleModelFromJson(jsonString);

import 'dart:convert';

ScreenTitleModel screenTitleModelFromJson(String str) => ScreenTitleModel.fromJson(json.decode(str));

String screenTitleModelToJson(ScreenTitleModel data) => json.encode(data.toJson());

class ScreenTitleModel {
  List<ScreenTitleItem>? screen;

  ScreenTitleModel({
    this.screen,
  });

  factory ScreenTitleModel.fromJson(Map<String, dynamic> json) => ScreenTitleModel(
        screen: json["screen"] == null ? [] : List<ScreenTitleItem>.from(json["screen"]!.map((x) => ScreenTitleItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "screen": screen == null ? [] : List<dynamic>.from(screen!.map((x) => x.toJson())),
      };
}

class ScreenTitleItem {
  String? name;
  String? id;

  ScreenTitleItem({
    this.name,
    this.id,
  });

  factory ScreenTitleItem.fromJson(Map<String, dynamic> json) => ScreenTitleItem(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

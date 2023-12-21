// To parse this JSON data, do
//
//     final addSymbolListModel = addSymbolListModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketdesktop/modelClass/tabWiseSymbolListModelClass.dart';

AddSymbolListModel addSymbolListModelFromJson(String str) => AddSymbolListModel.fromJson(json.decode(str));

String addSymbolListModelToJson(AddSymbolListModel data) => json.encode(data.toJson());

class AddSymbolListModel {
  Meta? meta;
  SymbolData? data;
  int? statusCode;
  String? message;

  AddSymbolListModel({
    this.meta,
    this.data,
    this.statusCode,
    this.message,
  });

  factory AddSymbolListModel.fromJson(Map<String, dynamic> json) => AddSymbolListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? null : SymbolData.fromJson(json["data"]),
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
        "message": message,
        "statusCode": statusCode,
      };
}

class Meta {
  String? message;

  Meta({
    this.message,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

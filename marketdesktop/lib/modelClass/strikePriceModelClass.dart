// To parse this JSON data, do
//
//     final strikePriceListModel = strikePriceListModelFromJson(jsonString);

import 'dart:convert';

StrikePriceListModel strikePriceListModelFromJson(String str) => StrikePriceListModel.fromJson(json.decode(str));

String strikePriceListModelToJson(StrikePriceListModel data) => json.encode(data.toJson());

class StrikePriceListModel {
  Meta? meta;
  List<StrikePriceData>? data;
  int? statusCode;

  StrikePriceListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory StrikePriceListModel.fromJson(Map<String, dynamic> json) => StrikePriceListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<StrikePriceData>.from(json["data"]!.map((x) => StrikePriceData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class StrikePriceData {
  String? symbolId;
  DateTime? expiryDate;
  String? masterName;
  int? strikePrice;
  String? name;

  StrikePriceData({
    this.symbolId,
    this.expiryDate,
    this.masterName,
    this.strikePrice,
    this.name,
  });

  factory StrikePriceData.fromJson(Map<String, dynamic> json) => StrikePriceData(
        symbolId: json["symbolId"],
        expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
        masterName: json["masterName"],
        strikePrice: json["strikePrice"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "symbolId": symbolId,
        "expiryDate": expiryDate?.toIso8601String(),
        "masterName": masterName,
        "strikePrice": strikePrice,
        "name": name,
      };
}

class Meta {
  String? message;
  int? totalCount;
  int? currentPage;
  int? limit;
  int? totalPage;

  Meta({
    this.message,
    this.totalCount,
    this.currentPage,
    this.limit,
    this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        message: json["message"],
        totalCount: json["totalCount"],
        currentPage: json["currentPage"],
        limit: json["limit"],
        totalPage: json["totalPage"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "totalCount": totalCount,
        "currentPage": currentPage,
        "limit": limit,
        "totalPage": totalPage,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

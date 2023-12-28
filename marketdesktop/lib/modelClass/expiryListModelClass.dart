// To parse this JSON data, do
//
//     final expiryListmodel = expiryListmodelFromJson(jsonString);

import 'dart:convert';

ExpiryListmodel expiryListmodelFromJson(String str) => ExpiryListmodel.fromJson(json.decode(str));

String expiryListmodelToJson(ExpiryListmodel data) => json.encode(data.toJson());

class ExpiryListmodel {
  Meta? meta;
  List<expiryData>? data;
  int? statusCode;

  ExpiryListmodel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory ExpiryListmodel.fromJson(Map<String, dynamic> json) => ExpiryListmodel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<expiryData>.from(json["data"]!.map((x) => expiryData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class expiryData {
  String? symbolId;
  DateTime? expiryDate;
  String? masterName;
  String? name;

  expiryData({
    this.symbolId,
    this.expiryDate,
    this.masterName,
    this.name,
  });

  factory expiryData.fromJson(Map<String, dynamic> json) => expiryData(
        symbolId: json["symbolId"],
        expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
        masterName: json["masterName"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "symbolId": symbolId,
        "expiryDate": expiryDate?.toIso8601String(),
        "masterName": masterName,
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

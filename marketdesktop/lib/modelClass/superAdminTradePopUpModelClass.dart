// To parse this JSON data, do
//
//     final superAdminPopUpModel = superAdminPopUpModelFromJson(jsonString);

import 'dart:convert';

SuperAdminPopUpModel superAdminPopUpModelFromJson(String str) => SuperAdminPopUpModel.fromJson(json.decode(str));

String superAdminPopUpModelToJson(SuperAdminPopUpModel data) => json.encode(data.toJson());

class SuperAdminPopUpModel {
  int? buyTotalQuantity;
  int? sellTotalQuantity;
  int? totalQuantity;
  String? symbolId;
  String? symbolName;
  String? symbolTitle;
  String? exchangeId;
  String? exchangeName;
  DateTime? startDate;
  DateTime? endDate;

  SuperAdminPopUpModel({
    this.buyTotalQuantity,
    this.sellTotalQuantity,
    this.totalQuantity,
    this.symbolId,
    this.symbolName,
    this.symbolTitle,
    this.exchangeId,
    this.exchangeName,
    this.startDate,
    this.endDate,
  });

  factory SuperAdminPopUpModel.fromJson(Map<String, dynamic> json) => SuperAdminPopUpModel(
        buyTotalQuantity: json["buyTotalQuantity"],
        sellTotalQuantity: json["sellTotalQuantity"],
        totalQuantity: json["totalQuantity"],
        symbolId: json["symbolId"],
        symbolName: json["symbolName"],
        symbolTitle: json["symbolTitle"],
        exchangeId: json["exchangeId"],
        exchangeName: json["exchangeName"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "buyTotalQuantity": buyTotalQuantity,
        "sellTotalQuantity": sellTotalQuantity,
        "totalQuantity": totalQuantity,
        "symbolId": symbolId,
        "symbolName": symbolName,
        "symbolTitle": symbolTitle,
        "exchangeId": exchangeId,
        "exchangeName": exchangeName,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      };
}

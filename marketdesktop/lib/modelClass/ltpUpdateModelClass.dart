// To parse this JSON data, do
//
//     final ltpUpdateModel = ltpUpdateModelFromJson(jsonString);

import 'dart:convert';

LtpUpdateModel ltpUpdateModelFromJson(String str) => LtpUpdateModel.fromJson(json.decode(str));

String ltpUpdateModelToJson(LtpUpdateModel data) => json.encode(data.toJson());

class LtpUpdateModel {
  String? symbolId;
  String? symbolTitle;
  num? ltp;
  DateTime? dateTime;

  LtpUpdateModel({
    this.symbolId,
    this.symbolTitle,
    this.ltp,
    this.dateTime,
  });

  factory LtpUpdateModel.fromJson(Map<String, dynamic> json) => LtpUpdateModel(
        symbolId: json["symbolId"],
        symbolTitle: json["symbolTitle"],
        ltp: json["ltp"]?.toDouble(),
        dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "symbolId": symbolId,
        "symbolTitle": symbolTitle,
        "ltp": ltp,
        "dateTime": dateTime?.toIso8601String(),
      };
}

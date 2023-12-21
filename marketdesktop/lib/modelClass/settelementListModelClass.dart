// To parse this JSON data, do
//
//     final settelementListModel = settelementListModelFromJson(jsonString);

import 'dart:convert';

SettlementListModel settelementListModelFromJson(String str) => SettlementListModel.fromJson(json.decode(str));

String settelementListModelToJson(SettlementListModel data) => json.encode(data.toJson());

class SettlementListModel {
  Meta? meta;
  SettelementData? data;
  int? statusCode;

  SettlementListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory SettlementListModel.fromJson(Map<String, dynamic> json) => SettlementListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? null : SettelementData.fromJson(json["data"]),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
        "statusCode": statusCode,
      };
}

class SettelementData {
  List<Profit>? profit;
  List<Profit>? loss;
  double plProfitGrandTotal = 0;
  double brkProfitGrandTotal = 0;
  double profitGrandTotal = 0;
  double plLossGrandTotal = 0;
  double brkLossGrandTotal = 0;
  double LossGrandTotal = 0;

  SettelementData({
    this.profit,
    this.loss,
  });

  factory SettelementData.fromJson(Map<String, dynamic> json) => SettelementData(
        profit: json["profit"] == null ? [] : List<Profit>.from(json["profit"]!.map((x) => Profit.fromJson(x))),
        loss: json["loss"] == null ? [] : List<Profit>.from(json["loss"]!.map((x) => Profit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "profit": profit == null ? [] : List<dynamic>.from(profit!.map((x) => x.toJson())),
        "loss": loss == null ? [] : List<dynamic>.from(loss!.map((x) => x.toJson())),
      };
}

class Profit {
  String? userId;
  String? parentId;
  String? userName;
  String? name;
  double? profitLoss;
  double? brokerageTotal;
  DateTime? createdAt;
  String? parentName;
  String? parentUserName;
  num? profitAndLossSharing;
  String? role;

  Profit({
    this.userId,
    this.parentId,
    this.userName,
    this.name,
    this.profitLoss,
    this.brokerageTotal,
    this.createdAt,
    this.parentName,
    this.parentUserName,
    this.profitAndLossSharing,
    this.role,
  });

  factory Profit.fromJson(Map<String, dynamic> json) => Profit(
        userId: json["userId"],
        parentId: json["parentId"],
        userName: json["userName"],
        name: json["name"],
        parentName: json["parentName"],
        parentUserName: json["parentUserName"],
        profitAndLossSharing: json["profitAndLossSharing"],
        profitLoss: json["profitLoss"]?.toDouble(),
        brokerageTotal: json["brokerageTotal"]?.toDouble(),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "parentId": parentId,
        "userName": userName,
        "name": name,
        "profitLoss": profitLoss,
        "brokerageTotal": brokerageTotal,
        "parentName": parentName,
        "parentUserName": parentUserName,
        "role": role,
        "profitAndLossSharing": profitAndLossSharing,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Meta {
  String? message;
  int? totalProfitCount;
  int? currentPage;
  int? limit;
  int? totalPage;

  Meta({
    this.message,
    this.totalProfitCount,
    this.currentPage,
    this.limit,
    this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        message: json["message"],
        totalProfitCount: json["totalProfitCount"],
        currentPage: json["currentPage"],
        limit: json["limit"],
        totalPage: json["totalPage"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "totalProfitCount": totalProfitCount,
        "currentPage": currentPage,
        "limit": limit,
        "totalPage": totalPage,
      };
}

// To parse this JSON data, do
//
//     final userLogListModel = userLogListModelFromJson(jsonString);

import 'dart:convert';

UserLogListModel userLogListModelFromJson(String str) => UserLogListModel.fromJson(json.decode(str));

String userLogListModelToJson(UserLogListModel data) => json.encode(data.toJson());

class UserLogListModel {
  Meta? meta;
  List<UserLogData>? data;
  int? statusCode;

  UserLogListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory UserLogListModel.fromJson(Map<String, dynamic> json) => UserLogListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<UserLogData>.from(json["data"]!.map((x) => UserLogData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class UserLogData {
  String? logId;
  String? userId;
  String? userName;
  String? parentId;
  int? oldStatus;
  String? oldStatusValue;
  int? status;
  String? statusValue;
  int? oldAutoSquareOff;
  String? oldAutoSquareOffValue;
  int? autoSquareOff;
  String? autoSquareOffValue;
  bool? oldViewOnly;
  String? oldViewOnlyValue;
  bool? viewOnly;
  String? viewOnlyValue;
  bool? oldBet;
  String? oldBetValue;
  bool? bet;
  String? betValue;
  bool? oldCloseOnly;
  String? oldCloseOnlyValue;
  bool? closeOnly;
  String? closeOnlyValue;
  bool? oldUpdatedBy;
  String? updatedBy;
  String? updatedByName;
  String? logStatus;
  DateTime? createdAt;

  UserLogData({
    this.logId,
    this.userId,
    this.userName,
    this.parentId,
    this.oldStatus,
    this.oldStatusValue,
    this.status,
    this.statusValue,
    this.oldAutoSquareOff,
    this.oldAutoSquareOffValue,
    this.autoSquareOff,
    this.autoSquareOffValue,
    this.oldViewOnly,
    this.oldViewOnlyValue,
    this.viewOnly,
    this.viewOnlyValue,
    this.oldBet,
    this.oldBetValue,
    this.bet,
    this.betValue,
    this.oldCloseOnly,
    this.oldCloseOnlyValue,
    this.closeOnly,
    this.closeOnlyValue,
    this.oldUpdatedBy,
    this.updatedBy,
    this.updatedByName,
    this.logStatus,
    this.createdAt,
  });

  factory UserLogData.fromJson(Map<String, dynamic> json) => UserLogData(
        logId: json["logId"],
        userId: json["userId"],
        userName: json["userName"],
        parentId: json["parentId"],
        oldStatus: json["oldStatus"],
        oldStatusValue: json["oldStatusValue"],
        status: json["status"],
        statusValue: json["statusValue"],
        oldAutoSquareOff: json["oldAutoSquareOff"],
        oldAutoSquareOffValue: json["oldAutoSquareOffValue"],
        autoSquareOff: json["autoSquareOff"],
        autoSquareOffValue: json["autoSquareOffValue"],
        oldViewOnly: json["oldViewOnly"],
        oldViewOnlyValue: json["oldViewOnlyValue"],
        viewOnly: json["viewOnly"],
        viewOnlyValue: json["viewOnlyValue"],
        oldBet: json["oldBet"],
        oldBetValue: json["oldBetValue"],
        bet: json["bet"],
        betValue: json["betValue"],
        oldCloseOnly: json["oldCloseOnly"],
        oldCloseOnlyValue: json["oldCloseOnlyValue"],
        closeOnly: json["closeOnly"],
        closeOnlyValue: json["closeOnlyValue"],
        oldUpdatedBy: json["oldUpdatedBy"],
        updatedBy: json["updatedBy"],
        updatedByName: json["updatedByName"],
        logStatus: json["logStatus"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "logId": logId,
        "userId": userId,
        "userName": userName,
        "parentId": parentId,
        "oldStatus": oldStatus,
        "oldStatusValue": oldStatusValue,
        "status": status,
        "statusValue": statusValue,
        "oldAutoSquareOff": oldAutoSquareOff,
        "oldAutoSquareOffValue": oldAutoSquareOffValue,
        "autoSquareOff": autoSquareOff,
        "autoSquareOffValue": autoSquareOffValue,
        "oldViewOnly": oldViewOnly,
        "oldViewOnlyValue": oldViewOnlyValue,
        "viewOnly": viewOnly,
        "viewOnlyValue": viewOnlyValue,
        "oldBet": oldBet,
        "oldBetValue": oldBetValue,
        "bet": bet,
        "betValue": betValue,
        "oldCloseOnly": oldCloseOnly,
        "oldCloseOnlyValue": oldCloseOnlyValue,
        "closeOnly": closeOnly,
        "closeOnlyValue": closeOnlyValue,
        "oldUpdatedBy": oldUpdatedBy,
        "updatedBy": updatedBy,
        "updatedByName": updatedByName,
        "logStatus": logStatus,
        "createdAt": createdAt?.toIso8601String(),
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

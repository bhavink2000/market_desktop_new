// To parse this JSON data, do
//
//     final ipTradeAlertModel = ipTradeAlertModelFromJson(jsonString);

import 'dart:convert';

IpTradeAlertModel ipTradeAlertModelFromJson(String str) => IpTradeAlertModel.fromJson(json.decode(str));

String ipTradeAlertModelToJson(IpTradeAlertModel data) => json.encode(data.toJson());

class IpTradeAlertModel {
    int? totalQuantity;
    String? symbolId;
    String? ipAddress;
    List<String>? userId;
    List<UserWiseDatum>? userWiseData;
    String? symbolName;
    String? symbolTitle;
    String? exchangeId;
    String? exchangeName;
    DateTime? startDate;
    DateTime? endDate;

    IpTradeAlertModel({
        this.totalQuantity,
        this.symbolId,
        this.ipAddress,
        this.userId,
        this.userWiseData,
        this.symbolName,
        this.symbolTitle,
        this.exchangeId,
        this.exchangeName,
        this.startDate,
        this.endDate,
    });

    factory IpTradeAlertModel.fromJson(Map<String, dynamic> json) => IpTradeAlertModel(
        totalQuantity: json["totalQuantity"],
        symbolId: json["symbolId"],
        ipAddress: json["ipAddress"],
        userId: json["userId"] == null ? [] : List<String>.from(json["userId"]!.map((x) => x)),
        userWiseData: json["userWiseData"] == null ? [] : List<UserWiseDatum>.from(json["userWiseData"]!.map((x) => UserWiseDatum.fromJson(x))),
        symbolName: json["symbolName"],
        symbolTitle: json["symbolTitle"],
        exchangeId: json["exchangeId"],
        exchangeName: json["exchangeName"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    );

    Map<String, dynamic> toJson() => {
        "totalQuantity": totalQuantity,
        "symbolId": symbolId,
        "ipAddress": ipAddress,
        "userId": userId == null ? [] : List<dynamic>.from(userId!.map((x) => x)),
        "userWiseData": userWiseData == null ? [] : List<dynamic>.from(userWiseData!.map((x) => x.toJson())),
        "symbolName": symbolName,
        "symbolTitle": symbolTitle,
        "exchangeId": exchangeId,
        "exchangeName": exchangeName,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
    };
}

class UserWiseDatum {
    int? totalQuantity;
    String? symbolId;
    String? ipAddress;
    String? userId;
    String? userName;
    String? symbolName;
    String? symbolTitle;
    String? exchangeId;
    String? exchangeName;
    DateTime? startDate;
    DateTime? endDate;

    UserWiseDatum({
        this.totalQuantity,
        this.symbolId,
        this.ipAddress,
        this.userId,
        this.userName,
        this.symbolName,
        this.symbolTitle,
        this.exchangeId,
        this.exchangeName,
        this.startDate,
        this.endDate,
    });

    factory UserWiseDatum.fromJson(Map<String, dynamic> json) => UserWiseDatum(
        totalQuantity: json["totalQuantity"],
        symbolId: json["symbolId"],
        ipAddress: json["ipAddress"],
        userId: json["userId"],
        userName: json["userName"],
        symbolName: json["symbolName"],
        symbolTitle: json["symbolTitle"],
        exchangeId: json["exchangeId"],
        exchangeName: json["exchangeName"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    );

    Map<String, dynamic> toJson() => {
        "totalQuantity": totalQuantity,
        "symbolId": symbolId,
        "ipAddress": ipAddress,
        "userId": userId,
        "userName": userName,
        "symbolName": symbolName,
        "symbolTitle": symbolTitle,
        "exchangeId": exchangeId,
        "exchangeName": exchangeName,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
    };
}

// To parse this JSON data, do
//
//     final viewProfileModel = viewProfileModelFromJson(jsonString);

import 'dart:convert';

ViewProfileModel viewProfileModelFromJson(String str) => ViewProfileModel.fromJson(json.decode(str));

String viewProfileModelToJson(ViewProfileModel data) => json.encode(data.toJson());

class ViewProfileModel {
  Meta? meta;
  ProfileInfoData? data;
  int? statusCode;

  ViewProfileModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory ViewProfileModel.fromJson(Map<String, dynamic> json) => ViewProfileModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? null : ProfileInfoData.fromJson(json["data"]),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
        "statusCode": statusCode,
      };
}

class ProfileInfoData {
  int? status;
  String? userId;
  String? name;
  String? userName;
  String? phone;
  double? credit;
  num? initialCredit;
  num? balance;
  String? remark;
  num? profitAndLossSharing;
  num? profitAndLossSharingDownLine;
  num? brkSharing;
  num? brkSharingDownLine;
  List<String>? exchangeAllow;
  List<String>? highLowBetweenTradeLimit;
  bool? firstLogin;
  bool? changePasswordOnFirstLogin;
  String? role;
  String? roleName;
  String? parentId;
  String? parentUser;
  bool? bet;
  bool? closeOnly;
  bool? marginSquareOff;
  bool? freshStopLoss;
  int? cmpOrder;
  String? cmpOrderValue;
  int? manualOrder;
  String? manualOrderValue;
  int? addMaster;
  String? addMasterValue;
  int? modifyOrder;
  int? marketOrder;
  String? modifyOrderValue;
  int? autoSquareOff;
  String? autoSquareOffValue;
  int? noOfLogin;
  String? lastLoginTime;
  String? lastLogoutTime;
  dynamic leverage;
  int? cutOff;
  int? intraday;
  String? intradayValue;
  DateTime? createdAt;
  String? ipAddress;
  String? deviceToken;
  String? deviceId;
  String? deviceType;
  num? profitLoss;
  num? brokerageTotal;
  num? tradeMarginBalance;
  num? marginBalance;
  int? executePendingOrder;
  String? executePendingOrderValue;
  int? deleteTrade;
  String? deleteTradeValue;
  bool? highLowSLLimitPercentage;

  ProfileInfoData({
    this.status,
    this.userId,
    this.name,
    this.userName,
    this.phone,
    this.credit,
    this.initialCredit,
    this.balance,
    this.remark,
    this.profitAndLossSharing,
    this.profitAndLossSharingDownLine,
    this.brkSharing,
    this.brkSharingDownLine,
    this.exchangeAllow,
    this.highLowBetweenTradeLimit,
    this.firstLogin,
    this.changePasswordOnFirstLogin,
    this.role,
    this.roleName,
    this.parentId,
    this.parentUser,
    this.marketOrder,
    this.bet,
    this.closeOnly,
    this.marginSquareOff,
    this.freshStopLoss,
    this.cmpOrder,
    this.cmpOrderValue,
    this.manualOrder,
    this.manualOrderValue,
    this.addMaster,
    this.addMasterValue,
    this.modifyOrder,
    this.modifyOrderValue,
    this.autoSquareOff,
    this.autoSquareOffValue,
    this.noOfLogin,
    this.lastLoginTime,
    this.lastLogoutTime,
    this.leverage,
    this.cutOff,
    this.intraday,
    this.intradayValue,
    this.createdAt,
    this.ipAddress,
    this.deviceToken,
    this.deviceId,
    this.deviceType,
    this.profitLoss,
    this.brokerageTotal,
    this.tradeMarginBalance,
    this.marginBalance,
    this.executePendingOrder,
    this.executePendingOrderValue,
    this.deleteTrade,
    this.deleteTradeValue,
    this.highLowSLLimitPercentage,
  });

  factory ProfileInfoData.fromJson(Map<String, dynamic> json) => ProfileInfoData(
        status: json["status"],
        userId: json["userId"],
        name: json["name"],
        userName: json["userName"],
        phone: json["phone"],
        credit: json["credit"]?.toDouble(),
        initialCredit: json["initialCredit"],
        balance: json["balance"]?.toDouble(),
        remark: json["remark"],
        profitAndLossSharing: json["profitAndLossSharing"],
        profitAndLossSharingDownLine: json["profitAndLossSharingDownLine"],
        brkSharing: json["brkSharing"],
        brkSharingDownLine: json["brkSharingDownLine"],
        exchangeAllow: json["exchangeAllow"] == null ? [] : List<String>.from(json["exchangeAllow"]!.map((x) => x)),
        highLowBetweenTradeLimit: json["highLowBetweenTradeLimit"] == null ? [] : List<String>.from(json["highLowBetweenTradeLimit"]!.map((x) => x)),
        firstLogin: json["firstLogin"],
        changePasswordOnFirstLogin: json["changePasswordOnFirstLogin"],
        role: json["role"],
        roleName: json["roleName"],
        parentId: json["parentId"],
        parentUser: json["parentUser"],
        bet: json["bet"],
        closeOnly: json["closeOnly"],
        marginSquareOff: json["marginSquareOff"],
        freshStopLoss: json["freshStopLoss"],
        cmpOrder: json["cmpOrder"],
        cmpOrderValue: json["cmpOrderValue"],
        manualOrder: json["manualOrder"],
        marketOrder: json["marketOrder"],
        manualOrderValue: json["manualOrderValue"],
        addMaster: json["addMaster"],
        addMasterValue: json["addMasterValue"],
        modifyOrder: json["modifyOrder"],
        modifyOrderValue: json["modifyOrderValue"],
        autoSquareOff: json["autoSquareOff"],
        autoSquareOffValue: json["autoSquareOffValue"],
        noOfLogin: json["noOfLogin"],
        lastLoginTime: json["lastLoginTime"],
        lastLogoutTime: json["lastLogoutTime"],
        leverage: json["leverage"].toString(),
        cutOff: json["cutOff"],
        intraday: int.tryParse(json["intraday"].toString()),
        intradayValue: json["intradayValue"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        ipAddress: json["ipAddress"],
        deviceToken: json["deviceToken"],
        deviceId: json["deviceId"],
        deviceType: json["deviceType"],
        profitLoss: json["profitLoss"]?.toDouble(),
        brokerageTotal: json["brokerageTotal"],
        tradeMarginBalance: json["tradeMarginBalance"],
        marginBalance: json["marginBalance"],
        executePendingOrder: json["executePendingOrder"],
        executePendingOrderValue: json["executePendingOrderValue"],
        deleteTrade: json["deleteTrade"],
        deleteTradeValue: json["deleteTradeValue"],
        highLowSLLimitPercentage: json["highLowSLLimitPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "userId": userId,
        "name": name,
        "userName": userName,
        "phone": phone,
        "credit": credit,
        "initialCredit": initialCredit,
        "balance": balance,
        "remark": remark,
        "profitAndLossSharing": profitAndLossSharing,
        "profitAndLossSharingDownLine": profitAndLossSharingDownLine,
        "brkSharing": brkSharing,
        "brkSharingDownLine": brkSharingDownLine,
        "exchangeAllow": exchangeAllow == null ? [] : List<dynamic>.from(exchangeAllow!.map((x) => x)),
        "highLowBetweenTradeLimit": highLowBetweenTradeLimit == null ? [] : List<dynamic>.from(highLowBetweenTradeLimit!.map((x) => x)),
        "firstLogin": firstLogin,
        "changePasswordOnFirstLogin": changePasswordOnFirstLogin,
        "role": role,
        "roleName": roleName,
        "parentId": parentId,
        "parentUser": parentUser,
        "bet": bet,
        "closeOnly": closeOnly,
        "marginSquareOff": marginSquareOff,
        "freshStopLoss": freshStopLoss,
        "cmpOrder": cmpOrder,
        "cmpOrderValue": cmpOrderValue,
        "manualOrder": manualOrder,
        "marketOrder": marketOrder,
        "manualOrderValue": manualOrderValue,
        "addMaster": addMaster,
        "addMasterValue": addMasterValue,
        "modifyOrder": modifyOrder,
        "modifyOrderValue": modifyOrderValue,
        "autoSquareOff": autoSquareOff,
        "autoSquareOffValue": autoSquareOffValue,
        "noOfLogin": noOfLogin,
        "lastLoginTime": lastLoginTime,
        "lastLogoutTime": lastLogoutTime,
        "leverage": leverage,
        "cutOff": cutOff,
        "intraday": intraday,
        "intradayValue": intradayValue,
        "createdAt": createdAt?.toIso8601String(),
        "ipAddress": ipAddress,
        "deviceToken": deviceToken,
        "deviceId": deviceId,
        "deviceType": deviceType,
        "profitLoss": profitLoss,
        "brokerageTotal": brokerageTotal,
        "tradeMarginBalance": tradeMarginBalance,
        "marginBalance": marginBalance,
        "executePendingOrder": executePendingOrder,
        "executePendingOrderValue": executePendingOrderValue,
        "highLowSLLimitPercentage": highLowSLLimitPercentage,
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

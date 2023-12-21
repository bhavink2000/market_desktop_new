// To parse this JSON data, do
//
//     final userListModel = userListModelFromJson(jsonString);

import 'dart:convert';

UserListModel userListModelFromJson(String str) => UserListModel.fromJson(json.decode(str));

String userListModelToJson(UserListModel data) => json.encode(data.toJson());

class UserListModel {
  Meta? meta;
  List<UserData>? data;
  int? statusCode;

  UserListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) => UserListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<UserData>.from(json["data"]!.map((x) => UserData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class UserData {
  int? status;
  String? userId;
  String? name;
  String? userName;
  String? phone;
  num? credit;
  num? initialCredit;
  num? tradeBalance;
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
  num? cmpOrder;
  String? cmpOrderValue;
  num? manualOrder;
  String? manualOrderValue;
  num? addMaster;
  String? addMasterValue;
  num? modifyOrder;
  String? modifyOrderValue;
  num? autoSquareOff;
  String? autoSquareOffValue;
  num? noOfLogin;
  DateTime? lastLoginTime;
  DateTime? lastLogoutTime;
  dynamic leverage;
  num? cutOff;
  num? intraday;
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

  UserData(
      {this.status,
      this.userId,
      this.name,
      this.userName,
      this.phone,
      this.credit,
      this.initialCredit,
      this.tradeBalance,
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
      this.marginBalance});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        status: json["status"],
        userId: json["userId"],
        name: json["name"],
        userName: json["userName"],
        phone: json["phone"],
        credit: json["credit"]?.toDouble(),
        initialCredit: json["initialCredit"],
        tradeBalance: json["balance"],
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
        manualOrderValue: json["manualOrderValue"],
        addMaster: json["addMaster"],
        addMasterValue: json["addMasterValue"],
        modifyOrder: json["modifyOrder"],
        modifyOrderValue: json["modifyOrderValue"],
        autoSquareOff: json["autoSquareOff"],
        autoSquareOffValue: json["autoSquareOffValue"],
        noOfLogin: json["noOfLogin"],
        lastLoginTime: json["lastLoginTime"] == null || json["lastLoginTime"] == "" ? null : DateTime.parse(json["lastLoginTime"]),
        lastLogoutTime: json["lastLogoutTime"] == null || json["lastLogoutTime"] == "" ? null : DateTime.parse(json["lastLogoutTime"]),
        leverage: json["leverage"],
        cutOff: json["cutOff"],
        intraday: json["intraday"],
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
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "userId": userId,
        "name": name,
        "userName": userName,
        "phone": phone,
        "credit": credit,
        "initialCredit": initialCredit,
        "tradeBalance": tradeBalance,
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
        "manualOrderValue": manualOrderValue,
        "addMaster": addMaster,
        "addMasterValue": addMasterValue,
        "modifyOrder": modifyOrder,
        "modifyOrderValue": modifyOrderValue,
        "autoSquareOff": autoSquareOff,
        "autoSquareOffValue": autoSquareOffValue,
        "noOfLogin": noOfLogin,
        "lastLoginTime": lastLoginTime?.toIso8601String(),
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

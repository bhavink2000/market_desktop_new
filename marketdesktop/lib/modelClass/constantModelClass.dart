// To parse this JSON data, do
//
//     final constantListModel = constantListModelFromJson(jsonString);

import 'dart:convert';

ConstantListModel constantListModelFromJson(String str) => ConstantListModel.fromJson(json.decode(str));

String constantListModelToJson(ConstantListModel data) => json.encode(data.toJson());

class ConstantListModel {
  Meta? meta;
  ConstantData? data;
  int? statusCode;

  ConstantListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory ConstantListModel.fromJson(Map<String, dynamic> json) => ConstantListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? null : ConstantData.fromJson(json["data"]),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
        "statusCode": statusCode,
      };
}

class ConstantData {
  List<String>? tradeAttribute;
  List<AddMaster>? allowTrade;
  List<AddMaster>? symbolStatus;
  List<AddMaster>? tradeTimingBy;
  List<Type>? orderType;
  List<Type>? tradeType;
  List<Type>? productType;
  List<AddMaster>? highLowBetweenTradeLimit;
  List<AddMaster>? oddLotTrade;
  List<AddMaster>? autoLotTrade;
  List<AddMaster>? exchangeStatus;
  List<Type>? brockerageType;
  List<AddMaster>? autoTickSize;
  List<AddMaster>? weekDays;
  List<AddMaster>? cmpOrder;
  List<AddMaster>? manualOrder;
  List<AddMaster>? addMaster;
  List<AddMaster>? modifyOrder;
  List<AddMaster>? autoSquareOff;
  List<AddMaster>? lotWise;
  List<AddMaster>? allPositionClose;
  List<AddMaster>? intraday;
  List<AddMaster>? leverageList;
  List<AddMaster>? status;
  List<AddMaster>? userFilterType;
  List<Type>? orderTypeFilter;
  String? serverName;
  List<Type>? transactionType;
  List<Type>? tradeStatusFilter;
  List<Type>? manuallyTradeAddedFor;
  List<Type>? productTypeForAccount;
  List<RoleDatum>? roleData;
  SettingData? settingData;

  ConstantData(
      {this.tradeAttribute,
      this.allowTrade,
      this.symbolStatus,
      this.tradeTimingBy,
      this.orderType,
      this.tradeType,
      this.productType,
      this.highLowBetweenTradeLimit,
      this.oddLotTrade,
      this.autoLotTrade,
      this.exchangeStatus,
      this.brockerageType,
      this.autoTickSize,
      this.weekDays,
      this.cmpOrder,
      this.manualOrder,
      this.addMaster,
      this.modifyOrder,
      this.autoSquareOff,
      this.lotWise,
      this.allPositionClose,
      this.intraday,
      this.leverageList,
      this.status,
      this.userFilterType,
      this.serverName,
      this.transactionType,
      this.roleData,
      this.settingData,
      this.orderTypeFilter,
      this.manuallyTradeAddedFor,
      this.productTypeForAccount,
      this.tradeStatusFilter});

  factory ConstantData.fromJson(Map<String, dynamic> json) => ConstantData(
        tradeAttribute: json["tradeAttribute"] == null ? [] : List<String>.from(json["tradeAttribute"]!.map((x) => x)),
        allowTrade: json["allowTrade"] == null ? [] : List<AddMaster>.from(json["allowTrade"]!.map((x) => AddMaster.fromJson(x))),
        symbolStatus: json["symbolStatus"] == null ? [] : List<AddMaster>.from(json["symbolStatus"]!.map((x) => AddMaster.fromJson(x))),
        tradeTimingBy: json["tradeTimingBy"] == null ? [] : List<AddMaster>.from(json["tradeTimingBy"]!.map((x) => AddMaster.fromJson(x))),
        orderType: json["orderType"] == null ? [] : List<Type>.from(json["orderType"]!.map((x) => Type.fromJson(x))),
        tradeType: json["tradeType"] == null ? [] : List<Type>.from(json["tradeType"]!.map((x) => Type.fromJson(x))),
        productType: json["productType"] == null ? [] : List<Type>.from(json["productType"]!.map((x) => Type.fromJson(x))),
        highLowBetweenTradeLimit: json["highLowBetweenTradeLimit"] == null ? [] : List<AddMaster>.from(json["highLowBetweenTradeLimit"]!.map((x) => AddMaster.fromJson(x))),
        oddLotTrade: json["oddLotTrade"] == null ? [] : List<AddMaster>.from(json["oddLotTrade"]!.map((x) => AddMaster.fromJson(x))),
        autoLotTrade: json["autoLotTrade"] == null ? [] : List<AddMaster>.from(json["autoLotTrade"]!.map((x) => AddMaster.fromJson(x))),
        exchangeStatus: json["exchangeStatus"] == null ? [] : List<AddMaster>.from(json["exchangeStatus"]!.map((x) => AddMaster.fromJson(x))),
        brockerageType: json["brockerageType"] == null ? [] : List<Type>.from(json["brockerageType"]!.map((x) => Type.fromJson(x))),
        autoTickSize: json["autoTickSize"] == null ? [] : List<AddMaster>.from(json["autoTickSize"]!.map((x) => AddMaster.fromJson(x))),
        weekDays: json["weekDays"] == null ? [] : List<AddMaster>.from(json["weekDays"]!.map((x) => AddMaster.fromJson(x))),
        cmpOrder: json["cmpOrder"] == null ? [] : List<AddMaster>.from(json["cmpOrder"]!.map((x) => AddMaster.fromJson(x))),
        manualOrder: json["manualOrder"] == null ? [] : List<AddMaster>.from(json["manualOrder"]!.map((x) => AddMaster.fromJson(x))),
        addMaster: json["addMaster"] == null ? [] : List<AddMaster>.from(json["addMaster"]!.map((x) => AddMaster.fromJson(x))),
        modifyOrder: json["modifyOrder"] == null ? [] : List<AddMaster>.from(json["modifyOrder"]!.map((x) => AddMaster.fromJson(x))),
        autoSquareOff: json["autoSquareOff"] == null ? [] : List<AddMaster>.from(json["autoSquareOff"]!.map((x) => AddMaster.fromJson(x))),
        lotWise: json["lotWise"] == null ? [] : List<AddMaster>.from(json["lotWise"]!.map((x) => AddMaster.fromJson(x))),
        allPositionClose: json["allPositionClose"] == null ? [] : List<AddMaster>.from(json["allPositionClose"]!.map((x) => AddMaster.fromJson(x))),
        intraday: json["intraday"] == null ? [] : List<AddMaster>.from(json["intraday"]!.map((x) => AddMaster.fromJson(x))),
        leverageList: json["leverageList"] == null ? [] : List<AddMaster>.from(json["leverageList"]!.map((x) => AddMaster.fromJson(x))),
        status: json["status"] == null ? [] : List<AddMaster>.from(json["status"]!.map((x) => AddMaster.fromJson(x))),
        userFilterType: json["userFilterType"] == null ? [] : List<AddMaster>.from(json["userFilterType"]!.map((x) => AddMaster.fromJson(x))),
        serverName: json["serverName"],
        transactionType: json["transactionType"] == null ? [] : List<Type>.from(json["transactionType"]!.map((x) => Type.fromJson(x))),
        roleData: json["roleData"] == null ? [] : List<RoleDatum>.from(json["roleData"]!.map((x) => RoleDatum.fromJson(x))),
        settingData: json["settingData"] == null ? null : SettingData.fromJson(json["settingData"]),
        orderTypeFilter: json["orderTypeFilter"] == null ? [] : List<Type>.from(json["orderTypeFilter"]!.map((x) => Type.fromJson(x))),
        tradeStatusFilter: json["tradeStatusFilter"] == null ? [] : List<Type>.from(json["tradeStatusFilter"]!.map((x) => Type.fromJson(x))),
        manuallyTradeAddedFor: json["manuallyTradeAddedFor"] == null ? [] : List<Type>.from(json["manuallyTradeAddedFor"]!.map((x) => Type.fromJson(x))),
        productTypeForAccount: json["productTypeForAccount"] == null ? [] : List<Type>.from(json["productTypeForAccount"]!.map((x) => Type.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tradeAttribute": tradeAttribute == null ? [] : List<dynamic>.from(tradeAttribute!.map((x) => x)),
        "allowTrade": allowTrade == null ? [] : List<dynamic>.from(allowTrade!.map((x) => x.toJson())),
        "symbolStatus": symbolStatus == null ? [] : List<dynamic>.from(symbolStatus!.map((x) => x.toJson())),
        "tradeTimingBy": tradeTimingBy == null ? [] : List<dynamic>.from(tradeTimingBy!.map((x) => x.toJson())),
        "orderType": orderType == null ? [] : List<dynamic>.from(orderType!.map((x) => x.toJson())),
        "tradeType": tradeType == null ? [] : List<dynamic>.from(tradeType!.map((x) => x.toJson())),
        "productType": productType == null ? [] : List<dynamic>.from(productType!.map((x) => x.toJson())),
        "highLowBetweenTradeLimit": highLowBetweenTradeLimit == null ? [] : List<dynamic>.from(highLowBetweenTradeLimit!.map((x) => x.toJson())),
        "oddLotTrade": oddLotTrade == null ? [] : List<dynamic>.from(oddLotTrade!.map((x) => x.toJson())),
        "autoLotTrade": autoLotTrade == null ? [] : List<dynamic>.from(autoLotTrade!.map((x) => x.toJson())),
        "exchangeStatus": exchangeStatus == null ? [] : List<dynamic>.from(exchangeStatus!.map((x) => x.toJson())),
        "brockerageType": brockerageType == null ? [] : List<dynamic>.from(brockerageType!.map((x) => x.toJson())),
        "autoTickSize": autoTickSize == null ? [] : List<dynamic>.from(autoTickSize!.map((x) => x.toJson())),
        "weekDays": weekDays == null ? [] : List<dynamic>.from(weekDays!.map((x) => x.toJson())),
        "cmpOrder": cmpOrder == null ? [] : List<dynamic>.from(cmpOrder!.map((x) => x.toJson())),
        "manualOrder": manualOrder == null ? [] : List<dynamic>.from(manualOrder!.map((x) => x.toJson())),
        "addMaster": addMaster == null ? [] : List<dynamic>.from(addMaster!.map((x) => x.toJson())),
        "modifyOrder": modifyOrder == null ? [] : List<dynamic>.from(modifyOrder!.map((x) => x.toJson())),
        "autoSquareOff": autoSquareOff == null ? [] : List<dynamic>.from(autoSquareOff!.map((x) => x.toJson())),
        "lotWise": lotWise == null ? [] : List<dynamic>.from(lotWise!.map((x) => x.toJson())),
        "allPositionClose": allPositionClose == null ? [] : List<dynamic>.from(allPositionClose!.map((x) => x.toJson())),
        "intraday": intraday == null ? [] : List<dynamic>.from(intraday!.map((x) => x.toJson())),
        "leverageList": leverageList == null ? [] : List<dynamic>.from(leverageList!.map((x) => x.toJson())),
        "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x.toJson())),
        "userFilterType": userFilterType == null ? [] : List<dynamic>.from(userFilterType!.map((x) => x.toJson())),
        "serverName": serverName,
        "roleData": roleData == null ? [] : List<dynamic>.from(roleData!.map((x) => x.toJson())),
        "orderTypeFilter": orderTypeFilter == null ? [] : List<dynamic>.from(orderTypeFilter!.map((x) => x.toJson())),
        "settingData": settingData?.toJson(),
        "tradeStatusFilter": tradeStatusFilter == null ? [] : List<dynamic>.from(tradeStatusFilter!.map((x) => x.toJson())),
        "manuallyTradeAddedFor": manuallyTradeAddedFor == null ? [] : List<dynamic>.from(manuallyTradeAddedFor!.map((x) => x.toJson())),
        "productTypeForAccount": productTypeForAccount == null ? [] : List<dynamic>.from(productTypeForAccount!.map((x) => x.toJson())),
      };
}

class RoleDatum {
  int? status;
  String? roleId;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  RoleDatum({
    this.status,
    this.roleId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory RoleDatum.fromJson(Map<String, dynamic> json) => RoleDatum(
        status: json["status"],
        roleId: json["roleId"],
        name: json["name"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "roleId": roleId,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class AddMaster {
  String? name;
  int? id;

  AddMaster({
    this.name,
    this.id,
  });

  factory AddMaster.fromJson(Map<String, dynamic> json) => AddMaster(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
  bool operator ==(dynamic other) {
    if (other is AddMaster) {
      return this.name == other.name;
    } else {
      return false;
    }
  }
}

class Type {
  String? name;
  String? id;

  Type({
    this.name,
    this.id,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
  bool operator ==(dynamic other) {
    if (other is Type) {
      return this.id == other.id;
    } else {
      return false;
    }
  }
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

class SettingData {
  String? banMessage;
  String? settingId;
  int? status;

  SettingData({
    this.banMessage,
    this.settingId,
    this.status,
  });

  factory SettingData.fromJson(Map<String, dynamic> json) => SettingData(
        banMessage: json["banMessage"],
        settingId: json["settingId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "banMessage": banMessage,
        "settingId": settingId,
        "status": status,
      };
}

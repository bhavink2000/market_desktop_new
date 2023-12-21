// To parse this JSON data, do
//
//     final exchangeListModel = exchangeListModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:marketdesktop/modelClass/groupListModelClass.dart';
import 'package:marketdesktop/constant/index.dart';

ExchangeListModel exchangeListModelFromJson(String str) => ExchangeListModel.fromJson(json.decode(str));

String exchangeListModelToJson(ExchangeListModel data) => json.encode(data.toJson());

class ExchangeListModel {
  Meta? meta;
  List<ExchangeData>? exchangeData;
  int? statusCode;

  ExchangeListModel({
    this.meta,
    this.exchangeData,
    this.statusCode,
  });

  factory ExchangeListModel.fromJson(Map<String, dynamic> json) => ExchangeListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        exchangeData: json["data"] == null ? [] : List<ExchangeData>.from(json["data"]!.map((x) => ExchangeData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": exchangeData == null ? [] : List<dynamic>.from(exchangeData!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class ExchangeData {
  String? exchangeId;
  String? name;
  String? tradeAttribute;
  int? highLowBetweenTradeLimit;
  String? highLowBetweenTradeLimitValue;
  int? oddLotTrade;
  String? oddLotTradeValue;
  String? brokarageType;
  int? autoTickSize;
  String? autoTickSizeValue;
  int? size;
  List<String>? orderType;
  int? autoLotSize;
  String? autoLotSizeValue;
  int? status;
  Rx<groupListModelData> isDropDownValueSelected = groupListModelData().obs;
  bool? isHighLowTradeSelected;
  bool? isExchangeAllowed;
  bool? isTurnOverSelected;
  bool? isSymbolSelected;
  bool isSelected = false;
  List<groupListModelData> selectedItems = [];
  RxString isDropDownValueSelectedID = "".obs;
  List<String> selectedItemsID = [];
  List<groupListModelData> arrGroupList = [];
  GlobalKey key = GlobalKey();
  FocusNode focusNode = FocusNode();

  ExchangeData({
    this.exchangeId,
    this.name,
    this.tradeAttribute,
    this.highLowBetweenTradeLimit,
    this.highLowBetweenTradeLimitValue,
    this.oddLotTrade,
    this.oddLotTradeValue,
    this.brokarageType,
    this.autoTickSize,
    this.autoTickSizeValue,
    this.size,
    this.orderType,
    this.autoLotSize,
    this.autoLotSizeValue,
    this.status,
    this.isTurnOverSelected,
    this.isSymbolSelected,
    this.isSelected = false,
    this.isHighLowTradeSelected,
    this.isExchangeAllowed,
  });

  factory ExchangeData.fromJson(Map<String, dynamic> json) => ExchangeData(
        exchangeId: json["exchangeId"],
        name: json["name"],
        tradeAttribute: json["tradeAttribute"],
        highLowBetweenTradeLimit: json["highLowBetweenTradeLimit"],
        highLowBetweenTradeLimitValue: json["highLowBetweenTradeLimitValue"],
        oddLotTrade: json["oddLotTrade"],
        oddLotTradeValue: json["oddLotTradeValue"],
        brokarageType: json["brokerageType"],
        autoTickSize: json["autoTickSize"],
        autoTickSizeValue: json["autoTickSizeValue"],
        size: json["size"],
        orderType: json["orderType"] == null ? [] : List<String>.from(json["orderType"]!.map((x) => x)),
        autoLotSize: json["autoLotSize"],
        autoLotSizeValue: json["autoLotSizeValue"],
        status: json["status"],
        isTurnOverSelected: false,
        isSymbolSelected: false,
        isSelected: false,
        isHighLowTradeSelected: false,
        isExchangeAllowed: false,
      );

  Map<String, dynamic> toJson() => {
        "exchangeId": exchangeId,
        "name": name,
        "tradeAttribute": tradeAttribute,
        "highLowBetweenTradeLimit": highLowBetweenTradeLimit,
        "highLowBetweenTradeLimitValue": highLowBetweenTradeLimitValue,
        "oddLotTrade": oddLotTrade,
        "oddLotTradeValue": oddLotTradeValue,
        "brokarageType": brokarageType,
        "autoTickSize": autoTickSize,
        "autoTickSizeValue": autoTickSizeValue,
        "size": size,
        "orderType": orderType == null ? [] : List<dynamic>.from(orderType!.map((x) => x)),
        "autoLotSize": autoLotSize,
        "autoLotSizeValue": autoLotSizeValue,
        "status": status,
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

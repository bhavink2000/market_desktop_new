// To parse this JSON data, do
//
//     final postitionModel = postitionModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';

PositionModel postitionModelFromJson(String str) => PositionModel.fromJson(json.decode(str));

String postitionModelToJson(PositionModel data) => json.encode(data.toJson());

class PositionModel {
  Meta? meta;
  List<positionListData>? data;
  int? statusCode;

  PositionModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) => PositionModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<positionListData>.from(json["data"]!.map((x) => positionListData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class positionListData {
  String? tradeId;
  String? userId;
  String? parentId;
  String? naOfUser;
  String? userName;
  String? symbolId;
  String? symbolName;
  String? symbolTitle;
  num? price;
  num? quantity;
  num? lotSize;
  num? totalQuantity;
  num? stopLoss;
  double? total;
  num? buyTotalQuantity;
  double? buyTotal;
  double? buyPrice;
  num? sellTotalQuantity;
  num? sellTotal;
  num? sellPrice;
  num? ask;
  num? bid;
  num? ltp;
  String? orderType;
  String? orderTypeValue;
  String? tradeType;
  String? tradeTypeValue;
  String? exchangeId;
  String? exchangeName;
  String? productType;
  String? productTypeValue;
  num? brokerageAmount;
  String? ipAddress;
  String? deviceId;
  String? orderMethod;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? currentPriceFromSocket;
  double? profitLossValue = 0;
  Rx<ScriptData> scriptDataFromSocket = ScriptData().obs;
  int? oddLotTrade;
  bool isSelected;
  String? parentUserName;
  num? profitAndLossSharing;

  positionListData({
    this.tradeId,
    this.userId,
    this.parentId,
    this.naOfUser,
    this.userName,
    this.symbolId,
    this.symbolName,
    this.symbolTitle,
    this.price,
    this.quantity,
    this.lotSize,
    this.totalQuantity,
    this.stopLoss,
    this.total,
    this.buyTotalQuantity,
    this.buyTotal,
    this.buyPrice,
    this.ask,
    this.bid,
    this.ltp,
    this.sellTotalQuantity,
    this.sellTotal,
    this.sellPrice,
    this.orderType,
    this.orderTypeValue,
    this.tradeType,
    this.tradeTypeValue,
    this.exchangeId,
    this.exchangeName,
    this.productType,
    this.productTypeValue,
    this.brokerageAmount,
    this.ipAddress,
    this.deviceId,
    this.orderMethod,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.oddLotTrade,
    this.isSelected = false,
    this.parentUserName,
    this.profitAndLossSharing,
  });

  factory positionListData.fromJson(Map<String, dynamic> json) => positionListData(
      tradeId: json["tradeId"],
      userId: json["userId"],
      parentId: json["parentId"],
      naOfUser: json["naOfUser"],
      userName: json["userName"],
      symbolId: json["symbolId"],
      symbolName: json["symbolName"],
      symbolTitle: json["symbolTitle"],
      price: json["price"]?.toDouble(),
      quantity: json["quantity"],
      lotSize: json["lotSize"],
      totalQuantity: json["totalQuantity"],
      stopLoss: json["stopLoss"],
      total: json["total"]?.toDouble(),
      buyTotalQuantity: json["buyTotalQuantity"],
      buyTotal: json["buyTotal"]?.toDouble(),
      buyPrice: json["buyPrice"]?.toDouble(),
      sellTotalQuantity: json["sellTotalQuantity"],
      sellTotal: json["sellTotal"],
      sellPrice: json["sellPrice"],
      ask: json["ask"] == "" || json["ask"] == null ? 0.0 : json["ask"],
      bid: json["bid"] == "" || json["bid"] == null ? 0.0 : json["bid"],
      ltp: json["ltp"] == "" || json["ltp"] == null ? 0.0 : json["ltp"],
      orderType: json["orderType"],
      orderTypeValue: json["orderTypeValue"],
      tradeType: json["tradeType"],
      tradeTypeValue: json["tradeTypeValue"],
      exchangeId: json["exchangeId"],
      exchangeName: json["exchangeName"],
      productType: json["productType"],
      productTypeValue: json["productTypeValue"],
      brokerageAmount: json["brokerageAmount"],
      ipAddress: json["ipAddress"],
      deviceId: json["deviceId"],
      orderMethod: json["orderMethod"],
      status: json["status"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      oddLotTrade: json["oddLotTrade"],
      parentUserName: json["parentUserName"],
      profitAndLossSharing: json["profitAndLossSharing"]);

  Map<String, dynamic> toJson() => {
        "tradeId": tradeId,
        "userId": userId,
        "parentId": parentId,
        "naOfUser": naOfUser,
        "userName": userName,
        "symbolId": symbolId,
        "symbolName": symbolName,
        "symbolTitle": symbolTitle,
        "price": price,
        "quantity": quantity,
        "lotSize": lotSize,
        "totalQuantity": totalQuantity,
        "stopLoss": stopLoss,
        "total": total,
        "buyTotalQuantity": buyTotalQuantity,
        "buyTotal": buyTotal,
        "buyPrice": buyPrice,
        "ask": ask,
        "bid": bid,
        "ltp": ltp,
        "sellTotalQuantity": sellTotalQuantity,
        "sellTotal": sellTotal,
        "sellPrice": sellPrice,
        "orderType": orderType,
        "orderTypeValue": orderTypeValue,
        "tradeType": tradeType,
        "tradeTypeValue": tradeTypeValue,
        "exchangeId": exchangeId,
        "exchangeName": exchangeName,
        "productType": productType,
        "productTypeValue": productTypeValue,
        "brokerageAmount": brokerageAmount,
        "ipAddress": ipAddress,
        "deviceId": deviceId,
        "orderMethod": orderMethod,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "oddLotTrade": oddLotTrade,
        "parentUserName": parentUserName,
        "profitAndLossSharing": profitAndLossSharing
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

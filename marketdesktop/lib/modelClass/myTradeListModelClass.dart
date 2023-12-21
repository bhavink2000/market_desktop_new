// To parse this JSON data, do
//
//     final myTradeListModel = myTradeListModelFromJson(jsonString);

import 'dart:convert';

MyTradeListModel myTradeListModelFromJson(String str) => MyTradeListModel.fromJson(json.decode(str));

String myTradeListModelToJson(MyTradeListModel data) => json.encode(data.toJson());

class MyTradeListModel {
  Meta? meta;
  List<TradeData>? data;
  int? statusCode;

  MyTradeListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory MyTradeListModel.fromJson(Map<String, dynamic> json) => MyTradeListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<TradeData>.from(json["data"]!.map((x) => TradeData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class TradeData {
  String? tradeId;
  String? userId;
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
  num? total;
  String? orderType;
  String? parentUserName;
  String? orderTypeValue;
  String? tradeType;
  String? tradeTypeValue;
  String? exchangeId;
  String? exchangeName;
  String? productType;
  String? productTypeMain;
  String? productTypeValue;
  num? brokerageAmount;
  String? ipAddress;
  String? deviceId;
  String? orderMethod;
  String? status;
  DateTime? createdAt;
  DateTime? executionDateTime;
  DateTime? updatedAt;
  num? oddLotTrade;
  double currentPriceFromSocket = 0.0;
  num? profitLoss = 0.0;
  bool isSelected = false;

  TradeData({
    this.tradeId,
    this.userId,
    this.naOfUser,
    this.userName,
    this.symbolId,
    this.symbolName,
    this.symbolTitle,
    this.price,
    this.quantity,
    this.parentUserName,
    this.productTypeMain,
    this.lotSize,
    this.totalQuantity,
    this.stopLoss,
    this.total,
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
    this.executionDateTime,
    this.updatedAt,
    this.profitLoss,
    this.oddLotTrade,
  });

  factory TradeData.fromJson(Map<String, dynamic> json) => TradeData(
      tradeId: json["tradeId"],
      userId: json["userId"],
      naOfUser: json["naOfUser"],
      userName: json["userName"],
      symbolId: json["symbolId"],
      symbolName: json["symbolName"],
      symbolTitle: json["symbolTitle"],
      price: json["price"],
      quantity: json["quantity"],
      parentUserName: json["parentUserName"],
      lotSize: json["lotSize"],
      totalQuantity: json["totalQuantity"],
      stopLoss: json["stopLoss"],
      total: json["total"],
      orderType: json["orderType"],
      productTypeMain: json["productTypeMain"],
      orderTypeValue: json["orderTypeValue"],
      tradeType: json["tradeType"],
      tradeTypeValue: json["tradeTypeValue"],
      exchangeId: json["exchangeId"],
      exchangeName: json["exchangeName"],
      productType: json["productType"],
      productTypeValue: json["productTypeValue"],
      brokerageAmount: json["brokerageAmount"],
      //is num == false ? 0 : json["brokerageAmount"],
      ipAddress: json["ipAddress"],
      deviceId: json["deviceId"],
      orderMethod: json["orderMethod"],
      status: json["status"],
      createdAt: json["createdAt"] == null || json["createdAt"] == "" ? null : DateTime.parse(json["createdAt"]),
      executionDateTime: json["executionDateTime"] == null || json["executionDateTime"] == "" ? null : DateTime.parse(json["executionDateTime"]),
      updatedAt: json["updatedAt"] == null || json["updatedAt"] == "" ? null : DateTime.parse(json["updatedAt"]),
      profitLoss: json["profitLoss"],
      oddLotTrade: json["oddLotTrade"]);

  Map<String, dynamic> toJson() => {
        "tradeId": tradeId,
        "userId": userId,
        "naOfUser": naOfUser,
        "userName": userName,
        "symbolId": symbolId,
        "symbolName": symbolName,
        "symbolTitle": symbolTitle,
        "price": price,
        "quantity": quantity,
        "parentUserName": parentUserName,
        "lotSize": lotSize,
        "totalQuantity": totalQuantity,
        "stopLoss": stopLoss,
        "total": total,
        "orderType": orderType,
        "orderTypeValue": orderTypeValue,
        "tradeType": tradeType,
        "tradeTypeValue": tradeTypeValue,
        "exchangeId": exchangeId,
        "exchangeName": exchangeName,
        "productTypeMain": productTypeMain,
        "productType": productType,
        "productTypeValue": productTypeValue,
        "brokerageAmount": brokerageAmount,
        "ipAddress": ipAddress,
        "deviceId": deviceId,
        "orderMethod": orderMethod,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "profitLoss": profitLoss,
        "oddLotTrade": oddLotTrade
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

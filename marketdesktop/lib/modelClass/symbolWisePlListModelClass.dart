// To parse this JSON data, do
//
//     final symbolWisePlListModel = symbolWisePlListModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';

SymbolWisePlListModel symbolWisePlListModelFromJson(String str) => SymbolWisePlListModel.fromJson(json.decode(str));

String symbolWisePlListModelToJson(SymbolWisePlListModel data) => json.encode(data.toJson());

class SymbolWisePlListModel {
  Meta? meta;
  List<SymbolWiseProfitLossData>? data;
  int? statusCode;

  SymbolWisePlListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory SymbolWisePlListModel.fromJson(Map<String, dynamic> json) => SymbolWisePlListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<SymbolWiseProfitLossData>.from(json["data"]!.map((x) => SymbolWiseProfitLossData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class SymbolWiseProfitLossData {
  String? transactionId;
  String? userId;
  String? userName;
  String? naOfUser;
  String? symbolTitle;
  String? symbolId;
  num? profitLoss;
  num? brokerageTotal;
  List<PositionDatum>? positionData;
  DateTime? createdAt;
  DateTime? updatedAt;
  num totalProfitLossValue = 0;
  num total = 0;
  num plWithBrk = 0;
  num netPL = 0;
  num childUserProfitLossTotal = 0.0;
  num childUserBrokerageTotal = 0.0;
  num parentBrokerageTotal = 0.0;

  SymbolWiseProfitLossData({
    this.transactionId,
    this.userId,
    this.userName,
    this.naOfUser,
    this.symbolTitle,
    this.symbolId,
    this.profitLoss,
    this.brokerageTotal,
    this.positionData,
    this.createdAt,
    this.updatedAt,
  });

  factory SymbolWiseProfitLossData.fromJson(Map<String, dynamic> json) => SymbolWiseProfitLossData(
        transactionId: json["transactionId"],
        userId: json["userId"],
        userName: json["userName"],
        naOfUser: json["naOfUser"],
        symbolTitle: json["symbolTitle"],
        symbolId: json["symbolId"],
        profitLoss: json["profitLoss"],
        brokerageTotal: json["brokerageTotal"],
        positionData: json["positionData"] == null ? [] : List<PositionDatum>.from(json["positionData"]!.map((x) => PositionDatum.fromJson(x))),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "userId": userId,
        "userName": userName,
        "naOfUser": naOfUser,
        "symbolTitle": symbolTitle,
        "symbolId": symbolId,
        "profitLoss": profitLoss,
        "brokerageTotal": brokerageTotal,
        "positionData": positionData == null ? [] : List<dynamic>.from(positionData!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class PositionDatum {
  String? id;
  String? userId;
  String? symbolId;
  String? symbolName;
  num? buyQuantity;
  double? buyPrice;
  num? buyLotSize;
  num? buyTotalQuantity;
  double? buyTotal;
  num? buyStopLoss;
  num? sellQuantity;
  num? sellPrice;
  num? sellLotSize;
  num? sellTotalQuantity;
  num? sellTotal;
  num? sellStopLoss;
  num? quantity;
  num? price;
  num? lotSize;
  num? totalQuantity;
  num? totalSlQuantity;
  num? slQuantity;
  double? total;
  num? stopLoss;
  String? productType;
  String? tradeType;
  num? tradeMargin;
  num? tradeMarginPrice;
  num? tradeMarginTotal;
  String? exchangeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  num? profitLossValue = 0;
  Rx<ScriptData> scriptDataFromSocket = ScriptData().obs;

  PositionDatum({
    this.id,
    this.userId,
    this.symbolId,
    this.symbolName,
    this.buyQuantity,
    this.buyPrice,
    this.buyLotSize,
    this.buyTotalQuantity,
    this.buyTotal,
    this.buyStopLoss,
    this.sellQuantity,
    this.sellPrice,
    this.sellLotSize,
    this.sellTotalQuantity,
    this.sellTotal,
    this.sellStopLoss,
    this.quantity,
    this.price,
    this.lotSize,
    this.totalQuantity,
    this.totalSlQuantity,
    this.slQuantity,
    this.total,
    this.stopLoss,
    this.productType,
    this.tradeType,
    this.tradeMargin,
    this.tradeMarginPrice,
    this.tradeMarginTotal,
    this.exchangeId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PositionDatum.fromJson(Map<String, dynamic> json) => PositionDatum(
        id: json["_id"],
        userId: json["userId"],
        symbolId: json["symbolId"],
        symbolName: json["symbolName"],
        buyQuantity: json["buyQuantity"],
        buyPrice: json["buyPrice"]?.toDouble(),
        buyLotSize: json["buyLotSize"],
        buyTotalQuantity: json["buyTotalQuantity"],
        buyTotal: json["buyTotal"]?.toDouble(),
        buyStopLoss: json["buyStopLoss"],
        sellQuantity: json["sellQuantity"],
        sellPrice: json["sellPrice"],
        sellLotSize: json["sellLotSize"],
        sellTotalQuantity: json["sellTotalQuantity"],
        sellTotal: json["sellTotal"],
        sellStopLoss: json["sellStopLoss"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        lotSize: json["lotSize"],
        totalQuantity: json["totalQuantity"],
        totalSlQuantity: json["totalSLQuantity"],
        slQuantity: json["slQuantity"],
        total: json["total"]?.toDouble(),
        stopLoss: json["stopLoss"],
        productType: json["productType"],
        tradeType: json["tradeType"],
        tradeMargin: json["tradeMargin"],
        tradeMarginPrice: json["tradeMarginPrice"]?.toDouble(),
        tradeMarginTotal: json["tradeMarginTotal"]?.toDouble(),
        exchangeId: json["exchangeId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "symbolId": symbolId,
        "symbolName": symbolName,
        "buyQuantity": buyQuantity,
        "buyPrice": buyPrice,
        "buyLotSize": buyLotSize,
        "buyTotalQuantity": buyTotalQuantity,
        "buyTotal": buyTotal,
        "buyStopLoss": buyStopLoss,
        "sellQuantity": sellQuantity,
        "sellPrice": sellPrice,
        "sellLotSize": sellLotSize,
        "sellTotalQuantity": sellTotalQuantity,
        "sellTotal": sellTotal,
        "sellStopLoss": sellStopLoss,
        "quantity": quantity,
        "price": price,
        "lotSize": lotSize,
        "totalQuantity": totalQuantity,
        "totalSLQuantity": totalSlQuantity,
        "slQuantity": slQuantity,
        "total": total,
        "stopLoss": stopLoss,
        "productType": productType,
        "tradeType": tradeType,
        "tradeMargin": tradeMargin,
        "tradeMarginPrice": tradeMarginPrice,
        "tradeMarginTotal": tradeMarginTotal,
        "exchangeId": exchangeId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
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

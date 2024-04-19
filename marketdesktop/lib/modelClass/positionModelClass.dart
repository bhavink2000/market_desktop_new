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
  // List<AllPositionData>? AllPositionDataObj;
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
  double plPerTotal = 0;
  num? tradeSecond;

  positionListData({
    // this.AllPositionDataObj,
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
    this.tradeSecond,
  });

  factory positionListData.fromJson(Map<String, dynamic> json) => positionListData(
        // AllPositionDataObj: json["positionData"] == null ? [] : List<AllPositionData>.from(json["positionData"]!.map((x) => AllPositionData.fromJson(x))),
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
        profitAndLossSharing: json["profitAndLossSharing"],
        tradeSecond: json["tradeSecond"],
      );

  Map<String, dynamic> toJson() => {
        // "positionData": AllPositionDataObj == null ? [] : List<dynamic>.from(AllPositionDataObj!.map((x) => x.toJson())),
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
        "profitAndLossSharing": profitAndLossSharing,
        "tradeSecond": tradeSecond,
      };
}

class AllPositionData {
  String? id;
  String? userId;
  String? symbolId;
  String? symbolName;
  num? buyQuantity;
  num? buyPrice;
  num? buyLotSize;
  num? buyTotalQuantity;
  num? buyTotal;
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
  num? totalLimitQuantity;
  num? limitQuantity;
  num? total;
  num? stopLoss;
  String? productType;
  String? tradeType;
  num? tradeMargin;
  num? tradeMarginPrice;
  num? tradeMarginTotal;
  num? profitLoss;
  num? brokerageTotal;
  bool? isRunCarryForward;
  String? exchangeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  num? profitAndLossSharing;
  double? profitLossValue = 0;
  AllPositionData({
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
    this.totalLimitQuantity,
    this.limitQuantity,
    this.total,
    this.stopLoss,
    this.productType,
    this.tradeType,
    this.tradeMargin,
    this.tradeMarginPrice,
    this.tradeMarginTotal,
    this.profitLoss,
    this.brokerageTotal,
    this.isRunCarryForward,
    this.exchangeId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.profitAndLossSharing,
  });

  factory AllPositionData.fromJson(Map<String, dynamic> json) => AllPositionData(
        id: json["_id"],
        userId: json["userId"],
        symbolId: json["symbolId"],
        symbolName: json["symbolName"],
        buyQuantity: json["buyQuantity"],
        buyPrice: json["buyPrice"],
        buyLotSize: json["buyLotSize"],
        buyTotalQuantity: json["buyTotalQuantity"],
        buyTotal: json["buyTotal"],
        buyStopLoss: json["buyStopLoss"],
        sellQuantity: json["sellQuantity"],
        sellPrice: json["sellPrice"],
        sellLotSize: json["sellLotSize"],
        sellTotalQuantity: json["sellTotalQuantity"],
        sellTotal: json["sellTotal"],
        sellStopLoss: json["sellStopLoss"],
        quantity: json["quantity"],
        price: json["price"],
        lotSize: json["lotSize"],
        totalQuantity: json["totalQuantity"],
        totalSlQuantity: json["totalSLQuantity"],
        slQuantity: json["slQuantity"],
        totalLimitQuantity: json["totalLimitQuantity"],
        limitQuantity: json["limitQuantity"],
        total: json["total"],
        stopLoss: json["stopLoss"],
        productType: json["productType"],
        tradeType: json["tradeType"],
        tradeMargin: json["tradeMargin"],
        tradeMarginPrice: json["tradeMarginPrice"]?.toDouble(),
        tradeMarginTotal: json["tradeMarginTotal"],
        profitLoss: json["profitLoss"],
        brokerageTotal: json["brokerageTotal"],
        isRunCarryForward: json["isRunCarryForward"],
        exchangeId: json["exchangeId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        profitAndLossSharing: json["profitAndLossSharing"],
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
        "totalLimitQuantity": totalLimitQuantity,
        "limitQuantity": limitQuantity,
        "total": total,
        "stopLoss": stopLoss,
        "productType": productType,
        "tradeType": tradeType,
        "tradeMargin": tradeMargin,
        "tradeMarginPrice": tradeMarginPrice,
        "tradeMarginTotal": tradeMarginTotal,
        "profitLoss": profitLoss,
        "brokerageTotal": brokerageTotal,
        "isRunCarryForward": isRunCarryForward,
        "exchangeId": exchangeId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "profitAndLossSharing": profitAndLossSharing,
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

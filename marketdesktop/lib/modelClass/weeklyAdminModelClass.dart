// To parse this JSON data, do
//
//     final weeklyAdminModel = weeklyAdminModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketdesktop/modelClass/m2mProfitLossModelClass.dart';

WeeklyAdminModel weeklyAdminModelFromJson(String str) => WeeklyAdminModel.fromJson(json.decode(str));

String weeklyAdminModelToJson(WeeklyAdminModel data) => json.encode(data.toJson());

class WeeklyAdminModel {
  Meta? meta;
  List<WeeklyAdminData>? data;
  int? statusCode;

  WeeklyAdminModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory WeeklyAdminModel.fromJson(Map<String, dynamic> json) => WeeklyAdminModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<WeeklyAdminData>.from(json["data"]!.map((x) => WeeklyAdminData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class WeeklyAdminData {
  String? userId;
  String? parentId;
  String? role;
  String? roleName;
  String? userName;
  String? name;
  num? balance;
  num? profitLoss;
  num? brokerageTotal;
  num? parentProfitLoss;
  num? parentBrokerageTotal;
  num? profitAndLossSharing;
  num? profitAndLossSharingDownLine;
  num? brkSharing;
  num? brkSharingDownLine;
  DateTime? createdAt;
  List<ChildUserDataPosition>? childUserDataPosition;
  double totalProfitLossValue = 0;
  num totalPl = 0;
  num brk = 0;
  num netPL = 0;
  num adminProfit = 0;
  num adminBrk = 0;
  num totalAdminBrk = 0;

  WeeklyAdminData({
    this.userId,
    this.parentId,
    this.role,
    this.roleName,
    this.userName,
    this.name,
    this.balance,
    this.profitLoss,
    this.brokerageTotal,
    this.parentProfitLoss,
    this.parentBrokerageTotal,
    this.profitAndLossSharing,
    this.profitAndLossSharingDownLine,
    this.brkSharing,
    this.brkSharingDownLine,
    this.createdAt,
    this.childUserDataPosition,
  });

  factory WeeklyAdminData.fromJson(Map<String, dynamic> json) => WeeklyAdminData(
        userId: json["userId"],
        parentId: json["parentId"],
        role: json["role"],
        roleName: json["roleName"],
        userName: json["userName"],
        name: json["name"],
        balance: json["balance"],
        profitLoss: json["profitLoss"],
        brokerageTotal: json["brokerageTotal"],
        parentProfitLoss: json["parentProfitLoss"],
        parentBrokerageTotal: json["parentBrokerageTotal"],
        profitAndLossSharing: json["profitAndLossSharing"],
        profitAndLossSharingDownLine: json["profitAndLossSharingDownLine"],
        brkSharing: json["brkSharing"],
        brkSharingDownLine: json["brkSharingDownLine"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        childUserDataPosition: json["childUserDataPosition"] == null
            ? []
            : List<ChildUserDataPosition>.from(json["childUserDataPosition"]!.map((x) => ChildUserDataPosition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "parentId": parentId,
        "role": role,
        "roleName": roleName,
        "userName": userName,
        "name": name,
        "balance": balance,
        "profitLoss": profitLoss,
        "brokerageTotal": brokerageTotal,
        "parentProfitLoss": parentProfitLoss,
        "parentBrokerageTotal": parentBrokerageTotal,
        "profitAndLossSharing": profitAndLossSharing,
        "profitAndLossSharingDownLine": profitAndLossSharingDownLine,
        "brkSharing": brkSharing,
        "brkSharingDownLine": brkSharingDownLine,
        "createdAt": createdAt?.toIso8601String(),
        "childUserDataPosition":
            childUserDataPosition == null ? [] : List<dynamic>.from(childUserDataPosition!.map((x) => x.toJson())),
      };
}

// class ChildUserDataPosition {
//     String? id;
//     String? userId;
//     String? symbolId;
//     String? symbolName;
//     int? buyQuantity;
//     double? buyPrice;
//     num? buyLotSize;
//     num? buyTotalQuantity;
//     double? buyTotal;
//     num? buyStopLoss;
//     num? sellQuantity;
//     num? sellPrice;
//     num? sellLotSize;
//     num? sellTotalQuantity;
//     num? sellTotal;
//     num? sellStopLoss;
//     num? quantity;
//     double? price;
//     int? lotSize;
//     int? totalQuantity;
//     double? total;
//     num? stopLoss;
//     String? productType;
//     String? tradeType;
//     String? exchangeId;
//     DateTime? createdAt;
//     DateTime? updatedAt;
//     num? v;

//     ChildUserDataPosition({
//         this.id,
//         this.userId,
//         this.symbolId,
//         this.symbolName,
//         this.buyQuantity,
//         this.buyPrice,
//         this.buyLotSize,
//         this.buyTotalQuantity,
//         this.buyTotal,
//         this.buyStopLoss,
//         this.sellQuantity,
//         this.sellPrice,
//         this.sellLotSize,
//         this.sellTotalQuantity,
//         this.sellTotal,
//         this.sellStopLoss,
//         this.quantity,
//         this.price,
//         this.lotSize,
//         this.totalQuantity,
//         this.total,
//         this.stopLoss,
//         this.productType,
//         this.tradeType,
//         this.exchangeId,
//         this.createdAt,
//         this.updatedAt,
//         this.v,
//     });

//     factory ChildUserDataPosition.fromJson(Map<String, dynamic> json) => ChildUserDataPosition(
//         id: json["_id"],
//         userId: json["userId"],
//         symbolId: json["symbolId"],
//         symbolName: json["symbolName"],
//         buyQuantity: json["buyQuantity"],
//         buyPrice: json["buyPrice"]?.toDouble(),
//         buyLotSize: json["buyLotSize"],
//         buyTotalQuantity: json["buyTotalQuantity"],
//         buyTotal: json["buyTotal"]?.toDouble(),
//         buyStopLoss: json["buyStopLoss"],
//         sellQuantity: json["sellQuantity"],
//         sellPrice: json["sellPrice"],
//         sellLotSize: json["sellLotSize"],
//         sellTotalQuantity: json["sellTotalQuantity"],
//         sellTotal: json["sellTotal"],
//         sellStopLoss: json["sellStopLoss"],
//         quantity: json["quantity"],
//         price: json["price"]?.toDouble(),
//         lotSize: json["lotSize"],
//         totalQuantity: json["totalQuantity"],
//         total: json["total"]?.toDouble(),
//         stopLoss: json["stopLoss"],
//         productType: json["productType"],
//         tradeType: json["tradeType"],
//         exchangeId: json["exchangeId"],
//         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userId": userId,
//         "symbolId": symbolId,
//         "symbolName": symbolName,
//         "buyQuantity": buyQuantity,
//         "buyPrice": buyPrice,
//         "buyLotSize": buyLotSize,
//         "buyTotalQuantity": buyTotalQuantity,
//         "buyTotal": buyTotal,
//         "buyStopLoss": buyStopLoss,
//         "sellQuantity": sellQuantity,
//         "sellPrice": sellPrice,
//         "sellLotSize": sellLotSize,
//         "sellTotalQuantity": sellTotalQuantity,
//         "sellTotal": sellTotal,
//         "sellStopLoss": sellStopLoss,
//         "quantity": quantity,
//         "price": price,
//         "lotSize": lotSize,
//         "totalQuantity": totalQuantity,
//         "total": total,
//         "stopLoss": stopLoss,
//         "productType": productType,
//         "tradeType": tradeType,
//         "exchangeId": exchangeId,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//     };
// }

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

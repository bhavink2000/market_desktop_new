// To parse this JSON data, do
//
//     final getScriptFromSocket = getScriptFromSocketFromJson(jsonString);

import 'dart:convert';

GetScriptFromSocket getScriptFromSocketFromJson(String str) => GetScriptFromSocket.fromJson(json.decode(str));

String getScriptFromSocketToJson(GetScriptFromSocket data) => json.encode(data.toJson());

class GetScriptFromSocket {
  bool? status;
  String? message;
  ScriptData? data;

  GetScriptFromSocket({
    this.status,
    this.message,
    this.data,
  });

  factory GetScriptFromSocket.fromJson(Map<String, dynamic> json) => GetScriptFromSocket(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ScriptData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ScriptData {
  num? bid;
  num? ask;
  num? ch;
  num? chp;
  num? ltp;
  num? open;
  num? high;
  num? low;
  num? close;
  num? volume;
  num? oi;
  num? tbq;
  num? tsq;
  num? ts;
  num? ls;
  DateTime? expiry;
  String? exchange;
  String? name;
  String? symbol;
  Depth? depth;
  DateTime? lut;

  ScriptData({
    this.bid = 0.0,
    this.ask = 0.0,
    this.ch = 0.0,
    this.chp = 0.0,
    this.ltp = 0.0,
    this.open = 0.0,
    this.high = 0.0,
    this.low = 0.0,
    this.close = 0.0,
    this.volume = 0.0,
    this.oi = 0.0,
    this.tbq = 0.0,
    this.tsq = 0.0,
    this.ts = 0.0,
    this.ls = 0.0,
    this.expiry,
    this.exchange = "",
    this.name = "",
    this.symbol = "",
    this.depth,
    this.lut,
  });

  factory ScriptData.fromJson(Map<String, dynamic> json) => ScriptData(
        bid: json["bid"] ?? 0.0,
        ask: json["ask"] ?? 0.0,
        ch: json["ch"] ?? 0.0,
        chp: json["chp"] ?? 0.0,
        ltp: json["ltp"] ?? 0.0,
        open: json["open"] ?? 0.0,
        high: json["high"] ?? 0.0,
        low: json["low"] ?? 0.0,
        close: json["close"] ?? 0.0,
        volume: json["volume"],
        oi: json["oi"],
        tbq: json["tbq"],
        tsq: json["tsq"],
        ts: json["ts"],
        ls: json["ls"],
        expiry: json["expiry"] == null ? null : DateTime.tryParse(json["expiry"]),
        exchange: json["exchange"] ?? "",
        name: json["name"] ?? "",
        symbol: json["symbol"] ?? "",
        depth: json["depth"] == null ? null : Depth.fromJson(json["depth"]),
      );

  Map<String, dynamic> toJson() => {
        "bid": bid,
        "ask": ask,
        "ch": ch,
        "chp": chp,
        "ltp": ltp,
        "open": open,
        "high": high,
        "low": low,
        "close": close,
        "volume": volume,
        "oi": oi,
        "tbq": tbq,
        "tsq": tsq,
        "ts": ts,
        "ls": ls,
        "expiry": expiry!.toIso8601String(),
        "exchange": exchange,
        "name": name,
        "symbol": symbol,
        "depth": depth?.toJson(),
      };
  bool operator ==(dynamic other) {
    if (other is ScriptData) {
      return this.symbol == other.symbol;
    } else {
      return false;
    }
  }

  copyObject(ScriptData other) {
    this.bid = other.bid;
    this.ask = other.ask;
    this.ch = other.ch;
    this.chp = other.chp;
    this.ltp = other.ltp;
    this.open = other.open;
    this.high = other.high;
    this.low = other.low;
    this.close = other.close;
    this.volume = other.volume;
    this.oi = other.oi;
    this.tbq = other.tbq;
    this.tsq = other.tsq;
    this.ts = other.ts;
    this.ls = other.ls;
    this.expiry = other.expiry;
    this.exchange = other.exchange;
    this.name = other.name;
    this.symbol = other.symbol;
    this.depth = other.depth;
    this.lut = other.lut;
  }
}

class Depth {
  List<Buy>? buy;
  List<Buy>? sell;

  Depth({
    this.buy,
    this.sell,
  });

  factory Depth.fromJson(Map<String, dynamic> json) => Depth(
        buy: json["buy"] == null ? [] : List<Buy>.from(json["buy"]!.map((x) => Buy.fromJson(x))),
        sell: json["sell"] == null ? [] : List<Buy>.from(json["sell"]!.map((x) => Buy.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "buy": buy == null ? [] : List<dynamic>.from(buy!.map((x) => x.toJson())),
        "sell": sell == null ? [] : List<dynamic>.from(sell!.map((x) => x.toJson())),
      };
}

class Buy {
  num? orders;
  num? price;
  num? quantity;

  Buy({
    this.orders,
    this.price,
    this.quantity,
  });

  factory Buy.fromJson(Map<String, dynamic> json) => Buy(
        orders: json["orders"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "orders": orders,
        "price": price,
        "quantity": quantity,
      };
}

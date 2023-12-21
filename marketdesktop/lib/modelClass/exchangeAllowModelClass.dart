class ExchangeAllowModel {
  List<ExchangeAllow>? exchangeAllow;

  ExchangeAllowModel({
    this.exchangeAllow,
  });

  factory ExchangeAllowModel.fromJson(Map<String, dynamic> json) =>
      ExchangeAllowModel(
        exchangeAllow: json["exchangeAllow"] == null
            ? []
            : List<ExchangeAllow>.from(
                json["exchangeAllow"]!.map((x) => ExchangeAllow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "exchangeAllow": exchangeAllow == null
            ? []
            : List<dynamic>.from(exchangeAllow!.map((x) => x.toJson())),
      };
}

class ExchangeAllow {
  String? exchangeId;
  bool? isTurnoverWise;
  bool? isSymbolWise;
  List<String>? groupId;

  ExchangeAllow({
    this.exchangeId,
    this.isTurnoverWise,
    this.isSymbolWise,
    this.groupId,
  });

  factory ExchangeAllow.fromJson(Map<String, dynamic> json) => ExchangeAllow(
        exchangeId: json["exchangeId"],
        isTurnoverWise: json["isTurnoverWise"],
        isSymbolWise: json["isSymbolWise"],
        groupId: json["groupId"] == null
            ? []
            : List<String>.from(json["groupId"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() {
    if (groupId!.isEmpty) {
      return {
        "exchangeId": exchangeId,
        "isTurnoverWise": isTurnoverWise,
        "isSymbolWise": isSymbolWise,
        "groupId": null
      };
    } else {
      return {
        "exchangeId": exchangeId,
        "isTurnoverWise": isTurnoverWise,
        "isSymbolWise": isSymbolWise,
        "groupId":
            groupId == null ? [] : List<dynamic>.from(groupId!.map((x) => x)),
      };
    }
  }
}

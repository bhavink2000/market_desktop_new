import 'dart:convert';

GroupListModel groupListModelFromJson(String str) => GroupListModel.fromJson(json.decode(str));

String groupListModelToJson(GroupListModel data) => json.encode(data.toJson());

class GroupListModel {
  Meta? meta;
  List<groupListModelData>? data;
  int? statusCode;

  GroupListModel({
    this.meta,
    this.data,
    this.statusCode,
  });

  factory GroupListModel.fromJson(Map<String, dynamic> json) => GroupListModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? [] : List<groupListModelData>.from(json["data"]!.map((x) => groupListModelData.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class groupListModelData {
  String? groupId;
  String? name;
  String? exchangeId;
  String? exchangeName;
  dynamic groupDefault;
  String? remark;
  int? status;
  String? updatedAt;

  groupListModelData({
    this.groupId = "",
    this.name = "",
    this.exchangeId = "",
    this.exchangeName = "",
    this.groupDefault = "",
    this.remark = "",
    this.status = -1,
    this.updatedAt = "",
  });

  factory groupListModelData.fromJson(Map<String, dynamic> json) => groupListModelData(
        groupId: json["groupId"],
        name: json["name"],
        exchangeId: json["exchangeId"],
        exchangeName: json["exchangeName"],
        groupDefault: json["groupDefault"],
        remark: json["remark"],
        status: json["status"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "name": name,
        "exchangeId": exchangeId,
        "exchangeName": exchangeName,
        "groupDefault": groupDefault,
        "remark": remark,
        "status": status,
        "updatedAt": updatedAt,
      };
  @override
  String toString() => name!;
  bool operator ==(dynamic other) {
    if (other is groupListModelData) {
      return this.groupId == other.groupId;
    } else {
      return false;
    }
  }
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

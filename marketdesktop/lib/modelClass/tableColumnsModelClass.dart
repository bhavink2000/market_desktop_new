import 'dart:ui';

class TableColumnModel {
  String? title;
  List<ColumnItem>? columnItems;

  TableColumnModel({
    this.title,
    this.columnItems,
  });

  factory TableColumnModel.fromJson(Map<String, dynamic> json) => TableColumnModel(
        title: json["title"],
        columnItems: json["columnItems"] == null ? [] : List<ColumnItem>.from(json["columnItems"]!.map((x) => ColumnItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "columnItems": columnItems == null ? [] : List<dynamic>.from(columnItems!.map((x) => x.toJson())),
      };
}

class ColumnItem {
  String? title;
  int? columnId;
  double? width;
  int? position;
  double? defaultWidth;
  Offset start = Offset.zero;
  ColumnItem({
    this.title,
    this.columnId,
    this.width,
    this.defaultWidth,
    this.position,
  });

  factory ColumnItem.fromJson(Map<String, dynamic> json) => ColumnItem(
        title: json["title"],
        columnId: json["columnId"],
        width: json["width"],
        defaultWidth: json["defaultWidth"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "columnId": columnId,
        "width": width,
        "defaultWidth": defaultWidth,
        "position": position,
      };
}

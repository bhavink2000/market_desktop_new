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
  double? width;
  int? position;
  int? screenId;
  String? columnId;

  double? updatedWidth;
  Offset start = Offset.zero;
  ColumnItem({
    this.title,
    this.width,
    this.updatedWidth,
    this.screenId,
    this.columnId,
    this.position,
  });

  factory ColumnItem.fromJson(Map<String, dynamic> json) => ColumnItem(
        title: json["title"],
        width: json["width"],
        screenId: json["screenId"],
        updatedWidth: json["updatedWidth"],
        columnId: json["columnId"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "width": width,
        "screenId": screenId,
        "updatedWidth": updatedWidth,
        "columnId": columnId,
        "position": position,
      };
  @override
  String toString() => title!;

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) {
    if (other is ColumnItem) {
      return this.screenId == other.screenId && this.title == other.title;
    } else {
      return false;
    }
  }
}

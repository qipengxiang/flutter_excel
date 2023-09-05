import 'package:flutter/material.dart';

import 'const/color.dart';

enum ExcelInputType {
  string,
  integer,
  float,
  date,
}

typedef ExcelPositionColorCondition = bool Function(int x, int y);
typedef ExcelSizeCondition = double Function(int xOrY);

class ExcelModel {
  final int x;
  final int y;

  final double itemWidth; // 列宽
  final double itemHeight; // 行高

  final double dividerWidth; // 分割线宽度

  final Color? rowColor; // 行颜色
  final ExcelPositionColorCondition? positionColor; // 行颜色条件
  final Color? columnColor; // 列颜色

  final ExcelSizeCondition? rowHeight; // 行高
  final ExcelSizeCondition? columnWidth; // 列宽

  final List<Color> neighborColors; // 邻居颜色

  final Color backgroundColor; // 背景颜色
  final Color? dividerColor; // 分割线颜色
  final Color? intersectionColor; // 横竖交集的颜色

  final List<ExcelPosition>? noNeighborColorPositions; // 不需要渲染邻居颜色的位置

  final ExcelInputType? defaultInputType; // 默认输入类型
  final bool isReadOnly; // 是否只读,此处为只读的时候,单元格的 isReadOnly 属性将无效

  final bool showSn; // 是否显示序号
  final ExcelSnModel? sn; // 序号
  final TextStyle? style;
  final Alignment alignment;

  ExcelModel({
    required this.x,
    required this.y,
    this.itemWidth = 80.0,
    this.itemHeight = 36.0,
    this.dividerWidth = 0.5,
    this.rowColor,
    this.columnColor,
    this.neighborColors = const <Color>[],
    this.backgroundColor = Colors.white,
    this.noNeighborColorPositions,
    this.rowHeight,
    this.columnWidth,
    Color? dividerColor,
    this.defaultInputType,
    this.showSn = false,
    ExcelSnModel? sn,
    this.isReadOnly = false,
    this.intersectionColor,
    this.positionColor,
    this.alignment = Alignment.centerLeft,
    TextStyle? style,
  })  : sn = sn ?? ExcelSnModel(),
        dividerColor = dividerColor ?? Colors.black.withOpacity(0.15),
        style = style ?? TextStyle(fontSize: 14.0, color: ThemeColor.primaryBlack.withOpacity(.45));
}

/// 序号属性,参考ExcelModel
class ExcelSnModel {
  final double itemWidth;
  final double itemHeight;
  final Color? backgroundColor;
  final Color? dividerColor;
  final TextStyle? style;

  ExcelSnModel({
    this.itemWidth = 20.0,
    this.itemHeight = 20.0,
    Color? backgroundColor,
    Color? dividerColor,
    TextStyle? style,
  })  : backgroundColor = backgroundColor ?? Colors.black.withOpacity(0.02),
        dividerColor = dividerColor ?? Colors.black.withOpacity(0.15),
        style = style ?? TextStyle(fontSize: 14.0, color: ThemeColor.primaryBlack.withOpacity(.45));
}

class ExcelItemModel<T extends ExcelItemImp> {
  final ExcelPosition position; // 在作为合并单元格的时候，position代表左上角的位置
  final List<ExcelPosition> positions;
  final bool isMergeCell; // 是否是合并单元格,如果是合并单元格,则 positions 不能为空
  T? value;
  final ExcelInputType inputType;
  final bool isReadOnly;
  final Color? color;
  final TextAlign textAlign;
  final TextStyle? style;
  final int? maxLine;
  final Widget? Function()? builder;

  final TextEditingController? controller;

  ExcelItemModel({
    required this.position,
    this.value,
    this.positions = const <ExcelPosition>[],
    this.isMergeCell = false,
    this.inputType = ExcelInputType.string,
    this.isReadOnly = false,
    this.color,
    this.textAlign = TextAlign.start,
    TextEditingController? controller,
    this.style,
    this.maxLine = 1,
    this.builder,
  })  : controller = controller ?? TextEditingController();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['position'] = position.toJson();
    json['positions'] = positions.map((e) => e.toJson()).toList();
    json['isMergeCell'] = isMergeCell;
    json['value'] = value?.value;
    json['inputType'] = inputType.index;
    json['isReadOnly'] = isReadOnly;
    json['color'] = color?.value;
    json['textAlign'] = textAlign.index;
    json['style'] = style?.toString();
    json['maxLine'] = maxLine;
    return json;
  }
}

class ExcelPosition {
  int x;
  int y;

  ExcelPosition(this.x, this.y);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['x'] = x;
    json['y'] = y;
    return json;
  }
}

abstract class ExcelItemImp {
  String? value;

  ExcelItemImp({this.value});
}

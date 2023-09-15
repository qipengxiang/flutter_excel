import 'package:flutter/cupertino.dart' as ios;
import 'package:flutter/material.dart';
import 'package:flutter_excel_table/src/ext/ext.dart';
import 'package:flutter_excel_table/src/widget/excel_line.dart';

import 'excel_model.dart';

class FlutterExcelWidget<T extends ExcelItemImp> extends StatelessWidget {
  final ExcelModel excel;
  final List<ExcelItemModel<T>> items;
  final Function(List<ExcelItemModel<T>> items, ExcelItemModel<T> model)? onItemClicked;
  final Function(List<ExcelItemModel<T>> items, ExcelItemModel<T>? model, String? value)? onItemChanged;

  final double? excelWidth; // excel total width ,default is screen width
  final double? excelHeight; // excel total height, default is screen height

  FlutterExcelWidget({
    Key? key,
    required this.excel,
    this.items = const [],
    this.onItemClicked,
    this.onItemChanged,
    this.excelWidth,
    this.excelHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_isExceed) {
      throw 'Excel data is out of range.';
    }
    if (!_isLegalMerge) {
      throw 'The merged cell location is invalid, or the positions attribute of the merged cells cannot be empty.';
    }
    final totalExcelWidth = excelWidth ?? MediaQuery.of(context).size.width;
    final totalExcelHeight = excelHeight ?? MediaQuery.of(context).size.height;
    double width = _getExcelWidth;
    double height = _getExcelHeight;
    _onScrollListener();
    _onExcelDataChanged();
    return Stack(
      children: [
        Positioned(
          left: (excel.sn?.itemWidth ?? excel.itemWidth) + excel.dividerWidth,
          child: SizedBox(
            width: totalExcelWidth,
            height: excel.sn?.itemHeight ?? excel.itemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _snHorizontalController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: excel.showSn ? excel.x : 0,
              itemBuilder: _buildHorizontalSnLineItems,
            ),
          ),
        ),
        Positioned(
          top: (excel.sn?.itemHeight ?? excel.itemHeight) + excel.dividerWidth,
          child: SizedBox(
            width: excel.sn?.itemWidth ?? excel.itemWidth,
            height: totalExcelHeight,
            child: ListView.builder(
              controller: _snVerticalController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: excel.showSn ? excel.y : 0,
              itemBuilder: _buildVerticalSnLineItems,
            ),
          ),
        ),
        Positioned(
          left: excel.showSn ? ((excel.sn?.itemWidth ?? excel.itemWidth) + excel.dividerWidth) : 0.0,
          top: excel.showSn ? ((excel.sn?.itemHeight ?? excel.itemHeight) + excel.dividerWidth) : 0.0,
          child: SizedBox(
            height: totalExcelHeight,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: _excelVerticalController,
              child: SizedBox(
                width: totalExcelWidth,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: _excelHorizontalController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    color: excel.backgroundColor,
                    constraints: BoxConstraints.expand(
                      width: width,
                      height: height,
                    ),
                    child: Stack(
                      children: _buildExcelLinesCells(width, height),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final ScrollController _snHorizontalController = ScrollController();
  final ScrollController _snVerticalController = ScrollController();

  final ScrollController _excelHorizontalController = ScrollController();
  final ScrollController _excelVerticalController = ScrollController();

  List<Widget> _buildExcelLinesCells(double totalWidth, double totalHeight) {
    List<Widget> widgets = <Widget>[];
    double left = 0;
    double itemWidth = excel.itemWidth;
    double itemHeight = excel.itemHeight;
    for (int i = 0; i <= excel.x; i++) {
      if (excel.columnWidth != null) {
        itemWidth = excel.columnWidth!(i);
      }
      // 划线
      if (excel.dividerWidth > 0) {
        final verticalLine = Positioned(
          left: left,
          top: 0.0,
          child: FlutterExcelLine(
            axis: FlutterExcelLineAxis.vertical,
            thickness: excel.dividerWidth,
            color: excel.dividerColor,
            length: totalHeight,
          ),
        );
        widgets.add(verticalLine);
      }
      left += (itemWidth + excel.dividerWidth);
    }
    double top = 0;
    if (excel.dividerWidth > 0) {
      // 划线
      for (int i = 0; i <= excel.y; i++) {
        if (excel.rowHeight != null) {
          itemHeight = excel.rowHeight!(i);
        }
        final horizontalLine = Positioned(
          left: 0.0,
          top: top,
          child: FlutterExcelLine(
            thickness: excel.dividerWidth,
            color: excel.dividerColor,
            length: totalWidth,
          ),
        );
        widgets.add(horizontalLine);
        top += (itemHeight + excel.dividerWidth);
      }
    }

    left = 0;
    for (int i = 0; i < excel.x; i++) {
      if (excel.columnWidth != null) {
        itemWidth = excel.columnWidth!(i);
      }
      top = 0;
      for (int j = 0; j < excel.y; j++) {
        if (excel.rowHeight != null) {
          itemHeight = excel.rowHeight!(j);
        }
        var model = items.flutterExcelFirstWhereOrNull((e) => e.position.x == i && e.position.y == j);
        Widget? widget = _itemBuilder(i, j, left, top, model: model);
        if (widget != null) {
          widgets.add(widget);
        }
        top += (itemHeight + excel.dividerWidth);
      }
      left += (itemWidth + excel.dividerWidth);
    }
    return widgets;
  }

  Widget? _itemBuilder(int x, int y, double left, double top, {ExcelItemModel<T>? model}) {
    Color? color;
    if (excel.positionColor != null) {
      if (excel.positionColor!(x, y)) {
        color = excel.rowColor;
      }
    }
    if (excel.neighborColors.isNotEmpty) {
      int startColorIndex = y % excel.neighborColors.length;
      color = excel.neighborColors[(startColorIndex + x) % excel.neighborColors.length];
    }
    if (excel.noNeighborColorPositions != null) {
      if (excel.noNeighborColorPositions!.where((e) => e.x == x && e.y == y).isNotEmpty) {
        color = null;
      }
    }
    if (excel.intersectionColor != null) {
      if (excel.positionColor != null) {
        bool inPosition = excel.positionColor!(x, y);
        if (inPosition) {
          color = excel.intersectionColor;
        }
      }
    }
    double width = excel.itemWidth;
    double height = excel.itemHeight;
    if (excel.columnWidth != null) {
      width = excel.columnWidth!(x);
    }
    if (excel.rowHeight != null) {
      height = excel.rowHeight!(y);
    }
    if (model != null) {
      if (model.isMergeCell) {
        if (model.positions.isNotEmpty) {
          if (!(x == model.position.x && y == model.position.y)) {
            return null;
          }
          List<int> xs = _getMergeMinMaxX(model.positions);
          List<int> ys = _getMergeMinMaxY(model.positions);
          width = 0;
          height = 0;
          for (int i = xs.first; i <= xs.last; i++) {
            double itemWidth = excel.itemWidth;
            if (excel.columnWidth != null) {
              itemWidth = excel.columnWidth!(i);
            }
            width += (itemWidth + excel.dividerWidth);
          }
          width -= excel.dividerWidth;
          for (int i = ys.first; i <= ys.last; i++) {
            double itemHeight = excel.itemHeight;
            if (excel.rowHeight != null) {
              itemHeight = excel.rowHeight!(i);
            }
            height += (itemHeight + excel.dividerWidth);
          }
          height -= excel.dividerWidth;
          color = model.color;
        }
      }
    } else {
      List<ExcelItemModel> merges = items.where((e) => e.isMergeCell).toList();
      for (var item in merges) {
        if (item.positions.where((e) => e.x == x && e.y == y).isNotEmpty) {
          return null;
        }
      }
    }
    return Positioned(
      left: left + excel.dividerWidth,
      top: top + excel.dividerWidth,
      child: Container(
        color: model?.color ?? color ?? Colors.white,
        constraints: BoxConstraints.expand(
          width: width,
          height: height,
        ),
        alignment: excel.alignment,
        child: _itemContentBuilder(x, y, model),
      ),
    );
  }

  Widget _itemContentBuilder(int x, int y, ExcelItemModel<T>? model) {
    model ??= ExcelItemModel<T>(position: ExcelPosition(x, y));
    if (model.builder != null) {
      final widget = model.builder!();
      if (widget != null) {
        return widget;
      }
    }
    TextInputType inputType = TextInputType.text;
    switch (model.inputType) {
      case ExcelInputType.integer:
        inputType = TextInputType.number;
        break;
      case ExcelInputType.float:
        inputType = const TextInputType.numberWithOptions(decimal: true);
        break;
      case ExcelInputType.date:
        inputType = TextInputType.datetime;
        break;
      default:
        inputType = TextInputType.text;
        break;
    }
    items.add(model);
    model.controller?.setDefaultValue(model.value?.value);
    return ios.CupertinoTextField(
      controller: model.controller,
      textAlign: model.textAlign,
      scribbleEnabled: true,
      readOnly: excel.isReadOnly ? excel.isReadOnly : model.isReadOnly,
      keyboardType: inputType,
      decoration: const BoxDecoration(),
      style: model.style ?? excel.style,
      maxLines: model.maxLine,
      onChanged: (String value) {
        model?.value?.value = value;
        _onExcelDataChanged(current: model);
      },
      onTap: () {
        if (excel.isReadOnly || (model?.isReadOnly ?? false)) {
          if (onItemClicked != null) {
            onItemClicked!(items, model!);
          }
          _onExcelDataChanged(current: model);
        }
      },
    );
  }

  List<int> _getMergeMinMaxX(List<ExcelPosition> position) {
    position.sort((a, b) => a.x.compareTo(b.x));
    int minX = position.first.x;
    int maxX = position.last.x;
    return [minX, maxX];
  }

  List<int> _getMergeMinMaxY(List<ExcelPosition> position) {
    position.sort((a, b) => a.y.compareTo(b.y));
    int minY = position.first.y;
    int maxY = position.last.y;
    return [minY, maxY];
  }

  bool get _isLegalMerge {
    // 非合并单元格,但是有多个单元格信息
    if (items.any((e) => !e.isMergeCell && e.positions.isNotEmpty)) {
      return false;
    }
    List<ExcelItemModel> merges = items.where((e) => e.isMergeCell).toList();
    for (ExcelItemModel merge in merges) {
      List<ExcelPosition> positions = merge.positions;
      if (positions.isNotEmpty) {
        positions.sort((a, b) => a.x.compareTo(b.x));
        int minX = positions.first.x;
        int minY = positions.first.y;
        return merge.position.x == minX && merge.position.y == minY;
      } else {
        // 是合并单元格,但是没有合并单元格信息
        return false;
      }
    }
    return true;
  }

  bool get _isExceed {
    List<int> rows = items.map((e) => e.position.x).toList();
    List<List<int>> mergeRow = items.map((e) => e.positions.map((e) => e.x).toList()).toList();
    rows.addAll(mergeRow.expand((e) => e));
    if (rows.isNotEmpty) {
      rows.sort((a, b) => a.compareTo(b));
      if (rows.last >= excel.x) {
        return false;
      }
    }
    List<int> columns = items.map((e) => e.position.y).toList();
    List<List<int>> mergeColumn = items.map((e) => e.positions.map((e) => e.y).toList()).toList();
    columns.addAll(mergeColumn.expand((e) => e));
    if (columns.isNotEmpty) {
      columns.sort((a, b) => a.compareTo(b));
      if (columns.last >= excel.y) {
        return false;
      }
    }
    return true;
  }

  void _onExcelDataChanged({ExcelItemModel<T>? current}) {
    if (onItemChanged != null) {
      onItemChanged?.call(items, current, current?.value?.value);
    }
  }
}

extension FlutterExcelSnWidget on FlutterExcelWidget {
  /// 纵向 1,2,3...
  Widget _buildVerticalSnLineItems(BuildContext context, int index) {
    if (!excel.showSn) {
      return const SizedBox.shrink();
    }
    double itemHeight = excel.itemHeight;
    if (excel.rowHeight != null) {
      itemHeight = excel.rowHeight!(index);
    }
    return Column(
      children: [
        if (index == 0)
          FlutterExcelLine(
            thickness: excel.dividerWidth,
            color: excel.sn?.dividerColor ?? excel.dividerColor,
            length: excel.sn?.itemWidth ?? excel.itemWidth,
          ),
        _buildSnItem(
          index,
          width: excel.sn?.itemWidth ?? excel.itemWidth,
          height: itemHeight,
          alignment: Alignment.centerRight,
        ),
        FlutterExcelLine(
          thickness: excel.dividerWidth,
          color: excel.sn?.dividerColor ?? excel.dividerColor,
          length: excel.sn?.itemWidth ?? excel.itemWidth,
        ),
      ],
    );
  }

  /// 横向 A,B,C...
  Widget _buildHorizontalSnLineItems(BuildContext context, int index) {
    if (!excel.showSn) {
      return const SizedBox.shrink();
    }
    double itemWidth = excel.itemWidth;
    if (excel.columnWidth != null) {
      itemWidth = excel.columnWidth!(index);
    }
    return Row(
      children: [
        if (index == 0)
          FlutterExcelLine(
            axis: FlutterExcelLineAxis.vertical,
            thickness: excel.dividerWidth,
            color: excel.sn?.dividerColor ?? excel.dividerColor,
            length: excel.sn?.itemHeight ?? excel.itemHeight,
          ),
        _buildSnItem(
          index,
          height: excel.sn?.itemHeight ?? excel.itemHeight,
          width: itemWidth,
          convert: true,
        ),
        FlutterExcelLine(
          axis: FlutterExcelLineAxis.vertical,
          thickness: excel.dividerWidth,
          color: excel.sn?.dividerColor ?? excel.dividerColor,
          length: excel.sn?.itemHeight ?? excel.itemHeight,
        ),
      ],
    );
  }

  Widget _buildSnItem(
    int index, {
    required double width,
    required double height,
    bool convert = false,
    Alignment alignment = Alignment.bottomCenter,
  }) {
    String value = '${index + 1}';
    if (convert) {
      index = index + 1;
      value = _convertSn(index);
    }
    return Container(
      color: excel.sn?.backgroundColor,
      constraints: BoxConstraints.expand(
        width: width,
        height: height,
      ),
      alignment: alignment,
      child: Text(
        value,
        style: excel.sn?.style,
      ),
    );
  }

  String _convertSn(int index) {
    String result = '';
    while (index > 0) {
      index--;
      int temp = index % 26;
      result = String.fromCharCode(65 + temp) + result;
      index ~/= 26;
    }
    return result;
  }
}

extension FlutterExcelSize on FlutterExcelWidget {
  double get _getExcelWidth {
    double width = 0;
    for (int i = 0; i < excel.x; i++) {
      double itemWidth = excel.itemWidth;
      if (excel.columnWidth != null) {
        itemWidth = excel.columnWidth!(i);
      }
      width += (itemWidth + excel.dividerWidth);
    }
    width += excel.dividerWidth;
    return width;
  }

  double get _getExcelHeight {
    double height = 0;
    for (int i = 0; i < excel.y; i++) {
      double itemHeight = excel.itemHeight;
      if (excel.rowHeight != null) {
        itemHeight = excel.rowHeight!(i);
      }
      height += (itemHeight + excel.dividerWidth);
    }
    height += excel.dividerWidth;
    return height;
  }
}

extension FlutterExcelWidgetScroll on FlutterExcelWidget {
  void _onScrollListener() {
    _excelHorizontalController.addListener(_onHorizontalScrolled);
    _excelVerticalController.addListener(_onVerticalScrolled);
  }

  void _onHorizontalScrolled() => _snHorizontalController.jumpTo(_excelHorizontalController.offset);

  void _onVerticalScrolled() => _snVerticalController.jumpTo(_excelVerticalController.offset);
}

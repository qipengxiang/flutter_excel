import 'dart:math';

import 'package:flutter/material.dart';

enum FlutterExcelLineAxis {
  horizontal,
  vertical,
}

class FlutterExcelLine extends StatelessWidget {
  final Color? color;
  final double prefix;
  final double suffix;
  final FlutterExcelLineAxis axis;
  final double thickness;
  final double length;

  ///
  /// [color] divider color
  /// [prefix] prefix spacing
  /// [suffix] suffix spacing
  /// [axis] axis
  /// [thickness] divider thickness
  /// [length] divider length
  FlutterExcelLine({
    Key? key,
    Color? color,
    this.prefix = 0.0,
    this.suffix = 0.0,
    this.axis = FlutterExcelLineAxis.horizontal,
    this.thickness = 1.0,
    this.length = double.infinity,
  })  : color = color ?? const Color(0xFFEFEFEF).withOpacity(0.6),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget line;
    switch (axis) {
      case FlutterExcelLineAxis.horizontal:
        line = _buildHorizontalLine();
        break;
      case FlutterExcelLineAxis.vertical:
        line = _buildVerticalLine();
        break;
    }
    return line;
  }

  Widget _buildVerticalLine() {
    double height = length;
    height = height - prefix - suffix;
    height = max(0.0, height);
    return SizedBox(
      width: thickness,
      height: height,
      child: VerticalDivider(
        color: color,
        thickness: thickness,
        width: thickness,
        indent: prefix,
        endIndent: suffix,
      ),
    );
  }

  Widget _buildHorizontalLine() {
    double width = length;
    width = width - prefix - suffix;
    width = max(0.0, width);
    return SizedBox(
      width: width,
      height: thickness,
      child: Divider(
        thickness: thickness,
        height: thickness,
        color: color,
        indent: prefix,
        endIndent: suffix,
      ),
    );
  }
}

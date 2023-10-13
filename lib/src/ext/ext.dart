import 'package:flutter/material.dart';

extension FirstWhereExt<T> on List<T> {
  T? flutterExcelFirstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension TextEditingControllerX on TextEditingController {
  ///
  /// [x] default value
  /// set textfield default value
  void setDefaultValue(dynamic x) {
    String xValue = (x ?? '').toString();
    value = TextEditingValue(
      text: xValue,
      selection: TextSelection.collapsed(offset: xValue.length),
      composing: TextRange.empty,
    );
  }
}

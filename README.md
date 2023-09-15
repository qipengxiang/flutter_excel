# flutter_excel_table

[![](https://img.shields.io/badge/flutter_excel_table-0.0.2-blue)](https://pub.dartlang.org/packages/flutter_excel_table)
![](https://img.shields.io/badge/Awesome-Flutter-blue)
![](https://img.shields.io/badge/Platform-Android_iOS_Web_Windows_MacOS_Linux-blue)
![](https://img.shields.io/badge/License-MIT-blue)

Language: English | [简体中文](README-ZH.md)

### Add dependencies to your project

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_excel_table: ^latestVersion
```

### Install

```shell
$ flutter pub get
```

### Import

```dart
import 'package:flutter_excel_table/flutter_excel_table.dart';
```

### CHANGELOG
- [CHANGELOG](./CHANGELOG.md)

### Usage

```dart
FlutterExcelWidget<ExcelExampleModel>(
  excel: ExcelModel(
    x: 16,
    y: 16,
    showSn: true,
    backgroundColor: Colors.white,
    rowColor: Colors.blue.withOpacity(.25),
    positionColor: (int x, int y) => y % 2 == 0,
  ),
  items: [
    ExcelItemModel(
      position: ExcelPosition(5, 3),
      value: ExcelExampleModel(value: '合并2222'),
      color: Colors.cyan,
      textAlign: TextAlign.end,
      isReadOnly: true,
      isMergeCell: true,
      style: const TextStyle(fontSize: 12, color: Colors.amberAccent),
      positions: [
        ExcelPosition(5, 3),
        ExcelPosition(5, 4),
        ExcelPosition(6, 3),
        ExcelPosition(6, 4),
        ExcelPosition(7, 3),
        ExcelPosition(7, 4),
      ],
    ),
    ExcelItemModel(
      position: ExcelPosition(0, 0),
      value: ExcelExampleModel(value: '10'),
      isReadOnly: true,
    ),
    ExcelItemModel(
      position: ExcelPosition(0, 1),
      value: ExcelExampleModel(value: '100'),
      inputType: ExcelInputType.date,
    ),
  ],
  onItemClicked: (items, item) {},
  onItemChanged: (items, item, value) {},
)
```

[More Example](./example/lib/main.dart)

### Example

#### Example-1
![](img/example-1.jpg)

#### Example-2
![](img/example-2.jpg)

#### Example-3
![](img/example-3.jpg)

#### Example-4
![](img/example-4.jpg)


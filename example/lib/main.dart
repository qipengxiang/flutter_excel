import 'package:flutter/material.dart';
import 'package:flutter_excel_table/flutter_excel_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScene(),
    );
  }
}

class HomeScene extends StatelessWidget {
  const HomeScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Demo'),
      ),
      body: ListView(
        children: [
          _buildItem(
            context,
            'Example-1',
            ExcelModel(
              x: 16,
              y: 36,
              showSn: true,
              backgroundColor: Colors.white,
              rowColor: Colors.blue.withOpacity(.25),
              positionColor: (int x, int y) => y % 2 == 0,
            ),
            <ExcelItemModel<ExcelExampleModel>>[
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
              ExcelItemModel(
                position: ExcelPosition(0, 2),
                value: ExcelExampleModel(value: '1000'),
                inputType: ExcelInputType.integer,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 3),
                value: ExcelExampleModel(value: '10000'),
                inputType: ExcelInputType.float,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 4),
                value: ExcelExampleModel(value: '2023-01-01'),
                isReadOnly: true,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 5),
                value: ExcelExampleModel(
                    value: '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                maxLine: 4,
                isReadOnly: true,
              ),
            ],
          ),
          _buildItem(
            context,
            'Example-2',
            ExcelModel(
              x: 18,
              y: 16,
              showSn: false,
              backgroundColor: Colors.white,
              rowColor: Colors.blue.withOpacity(.25),
              positionColor: (int x, int y) => y % 2 == 0,
              rowHeight: (y) => y == 2 ? 100 : 36,
              columnWidth: (x) => x % 2 == 0 ? 120 : 80,
            ),
            <ExcelItemModel<ExcelExampleModel>>[
              ExcelItemModel(
                position: ExcelPosition(3, 0),
                value: ExcelExampleModel(value: '合并1'),
                color: Colors.red,
                textAlign: TextAlign.center,
                isReadOnly: true,
                isMergeCell: true,
                positions: [
                  ExcelPosition(3, 0),
                  ExcelPosition(3, 1),
                  ExcelPosition(3, 2),
                  ExcelPosition(4, 0),
                  ExcelPosition(4, 1),
                  ExcelPosition(4, 2),
                ],
              ),
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
              ExcelItemModel(
                position: ExcelPosition(0, 2),
                value: ExcelExampleModel(value: '1000'),
                inputType: ExcelInputType.integer,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 3),
                value: ExcelExampleModel(value: '10000'),
                inputType: ExcelInputType.float,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 4),
                value: ExcelExampleModel(value: '2023-01-01'),
                isReadOnly: true,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 5),
                value: ExcelExampleModel(
                    value: '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                maxLine: 4,
                isReadOnly: true,
              ),
            ],
          ),
          _buildItem(
            context,
            'Example-3',
            ExcelModel(
              x: 18,
              y: 16,
              showSn: true,
              backgroundColor: Colors.white,
              rowColor: Colors.blue.withOpacity(.25),
              neighborColors: [
                Colors.red,
                Colors.orange,
              ],
              noNeighborColorPositions: [
                ExcelPosition(1, 0),
                ExcelPosition(1, 1),
                ExcelPosition(1, 2),
                ExcelPosition(1, 3),
                ExcelPosition(1, 4),
                ExcelPosition(1, 5),
              ],
            ),
            <ExcelItemModel<ExcelExampleModel>>[
              ExcelItemModel(
                position: ExcelPosition(3, 0),
                value: ExcelExampleModel(value: '合并1'),
                color: Colors.green,
                textAlign: TextAlign.center,
                isReadOnly: true,
                isMergeCell: true,
                positions: [
                  ExcelPosition(3, 0),
                  ExcelPosition(3, 1),
                  ExcelPosition(3, 2),
                  ExcelPosition(4, 0),
                  ExcelPosition(4, 1),
                  ExcelPosition(4, 2),
                ],
              ),
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
              ExcelItemModel(
                position: ExcelPosition(0, 2),
                value: ExcelExampleModel(value: '1000'),
                inputType: ExcelInputType.integer,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 3),
                value: ExcelExampleModel(value: '10000'),
                inputType: ExcelInputType.float,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 4),
                value: ExcelExampleModel(value: '2023-01-01'),
                isReadOnly: true,
              ),
              ExcelItemModel(
                position: ExcelPosition(0, 5),
                value: ExcelExampleModel(
                    value: '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                maxLine: 4,
                isReadOnly: true,
              ),
            ],
          ),
          _buildItem(
            context,
            'Example-4',
            ExcelModel(
              x: 5,
              y: 5,
              showSn: true,
              backgroundColor: Colors.white,
              rowColor: Colors.blue.withOpacity(.25),
              alignment: Alignment.centerRight,
            ),
            <ExcelItemModel<ExcelExampleModel>>[
              ExcelItemModel(
                position: ExcelPosition(0, 0),
                value: ExcelExampleModel(value: '10'),
                builder: () => const Icon(
                  Icons.ac_unit,
                  size: 10,
                  color: Colors.purple,
                ),
                isReadOnly: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, ExcelModel excel,
      List<ExcelItemModel<ExcelExampleModel>> items) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExampleScene(
              title: title,
              excel: excel,
              items: items,
            ),
          ),
        );
      },
    );
  }
}

class ExampleScene extends StatelessWidget {
  final String? title;
  final ExcelModel excel;
  final List<ExcelItemModel<ExcelExampleModel>> items;

  const ExampleScene({
    Key? key,
    this.title,
    required this.excel,
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Excel Example'),
      ),
      body: FlutterExcelWidget<ExcelExampleModel>(
        excel: excel,
        items: items,
        onItemClicked: (items, item) {},
        onItemChanged: (items, item, value) {},
      ),
    );
  }
}

class ExcelExampleModel extends ExcelItemImp {
  ExcelExampleModel({super.value});
}

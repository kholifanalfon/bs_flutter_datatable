import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:flutter/material.dart';

class ExampleSource extends BsDatatableSource {

  ExampleSource({
    List data = const [],
  }) : super(data: data);

  Function(dynamic, int) onEditListener = (value, index) {};
  Function(dynamic, int) onDeleteListener = (value, index) {};

  static List<BsDataColumn> get columns => <BsDataColumn>[
    BsDataColumn(label: Text('No'), orderable: false, searchable: false, width: 100.0),
    BsDataColumn(label: Text('Code'), columnName: 'typecd', width: 200.0),
    BsDataColumn(label: Text('Name'), columnName: 'typenm'),
    BsDataColumn(label: Text('Aksi'), orderable: false, searchable: false, width: 200.0),
  ];

  @override
  BsDataRow getRow(int index) {
    return BsDataRow(index: index, cells: <BsDataCell>[
      BsDataCell(Text('${controller.start + index + 1}')),
      BsDataCell(Text('${response.data[index]['typecd']}')),
      BsDataCell(Text('${response.data[index]['typenm']}')),
      BsDataCell(Row(
        children: [
          BsButton(
            margin: EdgeInsets.only(right: 5.0),
            onPressed: () => onEditListener(response.data[index]['typecd'], index),
            prefixIcon: Icons.edit,
            size: BsButtonSize.btnIconSm,
            style: BsButtonStyle.primary,
          ),
          BsButton(
            onPressed: () => onDeleteListener(response.data[index]['typecd'], index),
            prefixIcon: Icons.delete,
            size: BsButtonSize.btnIconSm,
            style: BsButtonStyle.danger,
          )
        ],
      ))
    ]);
  }
}

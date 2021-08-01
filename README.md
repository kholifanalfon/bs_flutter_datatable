# bs_flutter_datatable

Simple way to show data using datatable response with serverside processing

![Alt text](https://raw.githubusercontent.com/kholifanalfon/bs_flutter_datatable/main/screenshot/example.gif "Datatables Example")

Feature:
- Customize style
- Searchable data
- Pagination
- Pagelength
- Orderable
- Serverside processing


## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  bs_flutter_datatable: any
```

## Datatables
Example: [`main.dart`](https://github.com/kholifanalfon/bs_flutter_datatable/blob/main/example/lib/main.dart)

To create a select box you need to import:

```dart
import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
```

Create source datatable:
```dart
class ExampleSource extends BsDatatableSource {

  static List<BsDataColumn> get columns => <BsDataColumn>[
    BsDataColumn(label: Text('No'), orderable: false, searchable: false, width: 100.0),
    BsDataColumn(label: Text('Code'), columnName: 'typecd', width: 200.0),
    BsDataColumn(label: Text('Name'), columnName: 'typenm'),
  ];

  @override
  BsDataRow getRow(int index) {
    return BsDataRow(index: index, cells: <BsDataCell>[
      BsDataCell(Text('${controller.start + index + 1}')),
      BsDataCell(Text('${response.data[index]['typecd']}')),
      BsDataCell(Text('${response.data[index]['typenm']}')),
    ]);
  }
}
```

To create row event listener you musth defined listener on data source

```dart
class ExampleSource extends BsDatatableSource {

// ...

  ValueChanged<dynamic> onEditListener = (value) {};
  ValueChanged<dynamic> onDeleteListener = (value) {};

// ...

}
```

And then use variable on pressed action

```dart
// ...
@override
  BsDataRow getRow(int index) {
    return BsDataRow(index: index, cells: <BsDataCell>[
      // ...
      BsDataCell(Row(
        children: [
          TextButton(
            onPressed: () => onEditListener(response.data[index]['typeid']), 
            child: Container(child: Text('Edit'))
          ),
          TextButton(
            onPressed: () => onDeleteListener(response.data[index]['typeid']),
            child: Container(child: Text('Edit'))
          )
        ],
      ))
      // ...
    ]);
  }
// ...
```

To handle that listener, you can set after request data success

```dart
  Future loadApi(Map<String, dynamic> params) {
    return http.post(
      // ..
    ).then((value) {
      // ...
      setState(() {
        // ...
        _source.onEditListener = (typeid) {
          /// Do edit
        };
        _source.onDeleteListener = (typeid) {
          /// Do delete
        };
      });
    });
  }
```

declare source and controller datatable:

```dart
// ...
class _MyAppState extends State<MyApp> {

  ExampleSource _source = ExampleSource();

  @override
  void initState() {
    _source.controller = BsDatatableController();
    super.initState();
  }

// ...

}
```

create table view:

```dart
// ...
    BsDatatable(
      source: _source,
      title: Text('Datatables Data'),
      columns: ExampleSource.columns,
      serverSide: loadApi,
    )
// ...
```

Serverside function to get datatable response

```dart
// ...
  Future loadApi(Map<String, dynamic> params) {
    return http.post(
      Uri.parse('http://localhost/flutter_crud/api/public/types/datatables'),
      body: params,
    ).then((value) {
      Map<String, dynamic> json = jsonDecode(value.body);
      setState(() {
        _source.response = BsDatatableResponse.createFromJson(json['data']);
        _source.onEditListener = (typeid) {
          /// Do edit
        };
        _source.onDeleteListener = (typeid) {
          /// Do delete
        };
      });
    });
  }
// ...
```

### Note
- After request data from server has been successfully you need to update `response` data souece
```dart
// ...
  Future loadApi(Map<String, dynamic> params) {
    return http.post(
      // ...
    ).then((value) {
      // ...
      setState(() {
        /// Update response source data
        _source.response = BsDatatableResponse.createFromJson(json['data']);
        // ...
      });
    });
  }
// ..
```

To reload data you can use reload function
```dart
_source.controller.reload();
```

If you want to show data from List variable, you can add `data` to constructor source

```dart
class ExampleSource extends BsDatatableSource {

  ExampleSource({
    List? data,
  }) : super(data: data);

// ....
}
```

And now you cant set List variable in your widget

```dart
class Datatables extends StatefulWidget {
  @override
  _DatatablesState createState() => _DatatablesState();
}

class _DatatablesState extends State<Datatables> {

  ExampleSource _source1 = ExampleSource(
    data: [
      {'typecd': 'TP1', 'typenm': 'Type 1'},
      {'typecd': 'TP2', 'typenm': 'Type 2'},
      {'typecd': 'TP3', 'typenm': 'Type 3'},
      {'typecd': 'TP4', 'typenm': 'Type 4'},
      {'typecd': 'TP5', 'typenm': 'Type 5'},
    ]
  );

// ....

}
```

If you want to add data dynamicaly from button or anything, you can call method `add` or `addAll`. And if you want to update you call method `put` for remove call method `remove` or `removeAt`

```dart
// ...
    TextButton(
      onPressed: () {
        _source1.add({'typecd': 'TP1', 'typenm': 'Type ${_source1.datas.length}'});
      },
      child: Text('Add Row'),
    )
// ...
```
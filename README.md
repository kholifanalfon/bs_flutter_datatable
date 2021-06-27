# bs_flutter_datatable

Simple way to show data using datatable response with serverside processing

![Alt text](https://raw.githubusercontent.com/kholifanalfon/bs_flutter_datatable/main/screenshot/example.png "Datatables Example")

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
import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:flutter/material.dart';

class ExampleSource extends BsDatatableSource {

  BsDatatableResponse _response;

  ExampleSource({
    BsDatatableResponse response = const BsDatatableResponse(),
  }) : _response = response;

  @override
  // TODO: implement countData
  int get countData => _response.countData;

  @override
  // TODO: implement countDataPage
  int get countDataPage => _response.data.length;

  @override
  // TODO: implement countFiltered
  int get countFiltered => _response.countFiltered;

  @override
  BsDataRow getRow(int index) {
    return BsDataRow(
      index: index,
      cells: <BsDataCell>[
        BsDataCell(Text('${_response.start + index + 1}')),
        BsDataCell(Text('${_response.data[index]['typecd']}')),
        BsDataCell(Text('${_response.data[index]['typename']}')),
      ]
    );
  }

}
```

declare source and controller datatable:

```dart
ExampleSource _source = ExampleSource();
BsDatatableController _controller = BsDatatableController();
```

create table view:

```dart
// ...
  BsDatatable(
    source: _source,
    controller: _controller,
    searchable: true,
    pageLength: true,
    paginations: ['firstPage', 'previous', 'button', 'next', 'lastPage'],
    columns: <BsDataColumn>[
      BsDataColumn(label: Text('No'), orderable: false, searchable: false, width: 100.0),
      BsDataColumn(label: Text('Code'), width: 200.0,),
      BsDataColumn(label: Text('Name')),
    ],
    serverSide: loadApi,
  )
// ...
```
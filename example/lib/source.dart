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
import 'dart:convert';

import 'package:bs_flutter_card/bs_flutter_card.dart';
import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:bs_flutter_datatable_example/source.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ExampleSource _source = ExampleSource();

  @override
  void initState() {
    _source.controller = BsDatatableController();
    super.initState();
  }

  Future loadApi(Map<String, dynamic> params) {
    return http.post(
      Uri.parse('http://localhost/flutter_crud/api/public/types/datatables'),
      body: params,
    ).then((value) {
      Map<String, dynamic> json = jsonDecode(value.body);
      setState(() {
        _source.response = BsDatatableResponse.createFromJson(json['data']);
        _source.onEditListener = (typeid) {
          _source.controller.reload();
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Datatables.net'),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: BsCard(
                children: [
                  BsCardContainer(title: Text('Datatables')),
                  BsCardContainer(
                    child: BsDatatable(
                      source: _source,
                      title: Text('Datatables Data'),
                      columns: ExampleSource.columns,
                      pagination: BsPagination.input,
                      language: BsDatatableLanguage(
                        nextPagination: 'Next',
                        previousPagination: 'Previous',
                        information: 'Show __START__ to __END__ of __FILTERED__ entries',
                        informationFiltered: 'filtered from __DATA__ total entries',
                        firstPagination: 'First Page',
                        lastPagination: 'Last Page',
                        hintTextSearch: 'Search data ...',
                        perPageLabel: 'Page Length',
                        searchLabel: 'Search Form'
                      ),
                      serverSide: loadApi,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

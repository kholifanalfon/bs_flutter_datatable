import 'dart:convert';

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
  BsDatatableController _controller = BsDatatableController();

  @override
  void initState() {
    super.initState();
  }

  Future loadApi(Map<String, dynamic> params) {
    return http
        .post(
      Uri.parse('http://localhost/flutter_crud/api/public/types/datatables'),
      body: params,
    )
        .then((value) {
      Map<String, dynamic> json = jsonDecode(value.body);
      setState(() {
        _source = ExampleSource(
          response: BsDatatableResponse.createFromJson(json['data']),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: BsDatatable(
                source: _source,
                controller: _controller,
                searchable: true,
                pageLength: true,
                paginations: [
                  'previous',
                  'button',
                  'next',
                ],
                columns: <BsDataColumn>[
                  BsDataColumn(
                      label: Text('No'),
                      orderable: false,
                      searchable: false,
                      width: 100.0),
                  BsDataColumn(label: Text('Code'), columnName: 'typecd', columnData: 'typecd', width: 200.0),
                  BsDataColumn(label: Text('Name'), columnName: 'typenm', columnData: 'typenm'),
                ],
                serverSide: loadApi,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:bs_flutter_datatable/src/utils/bs_serverside.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BsDatatable extends StatefulWidget {

  const BsDatatable({
    Key? key,
    required this.controller,
    required this.serverSide,
    required this.columns,
    required this.source,
    this.width,
    this.searchable = true,
    this.pageLength = true,
    this.hintStyleSearch,
    this.title,
    this.titleTextStyle,
    this.paginations = const ['firstPage', 'previous', 'button', 'next', 'lastPage'],
    this.notFoundText,
    this.processingText,
    this.prependLeftHeader = const [],
    this.appendLeftHeader = const [],
    this.prependRightHeader = const [],
    this.appendRightHeader = const [],
    this.prependLeftFooter = const [],
    this.appendLeftFooter = const [],
    this.prependRightFooter = const [],
    this.appendRightFooter = const [],
    this.textInfo,
    this.textInfoStyle,
    this.style = const BsDatatableStyle(),
    this.stylePagination = const BsPaginateButtonStyle(),
    this.language = const BsDatatableLanguage(),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BsDatatableState();
  }

  final double? width;

  final bool searchable;

  final Widget? title;

  final TextStyle? titleTextStyle;

  final List<String> paginations;

  final Widget? notFoundText;

  final Widget? processingText;

  final bool pageLength;

  final TextStyle? hintStyleSearch;

  final List<Widget> prependLeftHeader;

  final List<Widget> appendLeftHeader;

  final List<Widget> prependRightHeader;

  final List<Widget> appendRightHeader;

  final List<Widget> prependLeftFooter;

  final List<Widget> appendLeftFooter;

  final List<Widget> prependRightFooter;

  final List<Widget> appendRightFooter;

  final Widget? textInfo;

  final TextStyle? textInfoStyle;

  final List<BsDataColumn> columns;

  final BsDatatableSource source;

  final BsDatatableController controller;

  final BsDatatableServerSide serverSide;

  final BsDatatableLanguage language;

  final BsDatatableStyle style;

  final BsPaginateButtonStyle stylePagination;
}

class _BsDatatableState extends State<BsDatatable> {

  Timer? _timer;

  bool _processing = false;
  TextEditingController _inputSearch = TextEditingController();
  TextEditingController _inputLength = TextEditingController();
  TextEditingController _inputPage = TextEditingController(text: '1');

  late List<BsDataColumn> _currentColumns;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    widget.controller.refresh = () {

      widget.controller.columns = [];
      _currentColumns.forEach((column) {
        String index = _currentColumns.indexOf(column).toString();
        String columnData = column.columnData != null ? column.columnData! : index;

        widget.controller.columns.add({
          'data': columnData,
          'name': column.columnName != null ? column.columnName! : '',
          'orderable': column.orderable.toString(),
          'searchable': column.searchable.toString(),
          'searchvalue': column.searchValue,
          'searchregex': column.searchRegex
        });

        if(column.orderState.ordered) {
          widget.controller.orders.add({
            'column': columnData,
            'dir': column.orderState.orderType,
          });
        }

        if(widget.controller.orders.length == 0 && column.orderable) {
          widget.controller.orders = [];
          column.orderState = BsOrderColumn(ordered: true, orderType: BsOrderColumn.asc);
          widget.controller.orders.add({
            'column': columnData,
            'dir': column.orderState.orderType,
          });
        }
      });

      setState(() {
        _processing = true;
      });
      widget.serverSide(widget.controller.toJson()).then((value) {
        setState(() {
          _processing = false;
          widget.controller.draw++;
        });
      });
    };

    _currentColumns = List<BsDataColumn>.from(widget.columns);
    _inputLength.text = widget.controller.length.toString();

    widget.controller.refresh();
  }

  void doneTyping(dynamic value, ValueChanged<dynamic> callback) {
    if (_timer != null) _timer!.cancel();

    _timer = Timer(Duration(milliseconds: 500), () => callback(value));
  }

  String replaceText(String text) {
    String start = text.replaceAll('__START__', (widget.controller.start + 1).toString());
    String end = start.replaceAll('__END__', (widget.controller.start + widget.source.countDataPage).toString());
    String data = end.replaceAll('__DATA__', widget.source.countData.toString());
    String filtered = data.replaceAll('__FILTERED__', widget.source.countFiltered.toString());

    return filtered;
  }

  Widget textInformation() {
    String text = replaceText(widget.language.information);
    if(widget.controller.searchValue != '')
      text = replaceText('${widget.language.information} (${widget.language.informationFiltered})');

    return widget.textInfo != null ? widget.textInfo! : Text(text, style: TextStyle(
      fontSize: 12.0
    ).merge(widget.textInfoStyle));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    children: [
                      Column(children: widget.prependLeftHeader),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 18.0,
                        ).merge(widget.titleTextStyle),
                        child: widget.title != null ? widget.title! : Text('Table Title')
                      ),
                      Column(children: widget.appendLeftHeader),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Column(children: widget.prependRightHeader),
                      widget.pageLength == false ? Container() : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 2.0),
                            child: Text(widget.language.perPageLabel, style: TextStyle(
                              fontSize: 10.0
                            )),
                          ),
                          Container(
                            width: 60.0,
                            margin: EdgeInsets.only(right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: widget.style.borderColor),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: TextField(
                              controller: _inputLength,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey
                                ),
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) => doneTyping(value, (value) {
                                if(value == '' || int.parse(value) <= 0) {
                                  widget.controller.start = 0;
                                  widget.controller.length = 10;
                                  _inputLength.text = '10';
                                  widget.controller.refresh();
                                } else {
                                  int length = int.parse(value);
                                  
                                  widget.controller.start = 0;
                                  widget.controller.length = length;
                                  widget.controller.refresh();
                                }
                              }),
                            ),
                          )
                        ],
                      ),
                      widget.searchable == false ? Container() : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 2.0),
                            child: Text(widget.language.searchLabel, style: TextStyle(
                              fontSize: 10.0
                            )),
                          ),
                          Container(
                            width: 250.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: widget.style.borderColor),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: TextField(
                              controller: _inputSearch,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
                                hintText: widget.language.hintTextSearch,
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey
                                ).merge(widget.hintStyleSearch),
                                isDense: true,
                              ),
                              onChanged: (value) => doneTyping(value, (value) {
                                widget.controller.searchValue = value;
                                widget.controller.start = 0;
                                widget.controller.refresh();
                              }),
                            ),
                          )
                        ],
                      ),
                      Column(children: widget.appendRightHeader)
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(children: [Expanded(child: table())]),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(children: widget.prependLeftFooter),
                    Container(child: textInformation()),
                    Column(children: widget.appendLeftFooter)
                  ],
                ),
                Row(
                  children: [
                    Column(children: widget.prependRightFooter),
                    Container(child: pagination()),
                    Column(children: widget.appendRightFooter)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> get columnsWidths {
    Map<int, TableColumnWidth> _columnsWidths = Map<int, TableColumnWidth>();

    _currentColumns.forEach((column) {
      if(column.width != null)
        _columnsWidths.addAll({_currentColumns.indexOf(column): FixedColumnWidth(column.width!)});
    });

    return _columnsWidths;
  }

  List<Widget> get columns {
    List<Widget> _columns = [];

    _currentColumns.forEach((column) {
      _columns.add(TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(double.infinity, 10.0),
        ),
        onPressed: column.orderable == false ? null : () {

          String dir = BsOrderColumn.def;
          if(column.orderState.orderType == BsOrderColumn.def
              || column.orderState.orderType == BsOrderColumn.desc)
            dir = BsOrderColumn.asc;
          else if(column.orderState.orderType == BsOrderColumn.asc)
            dir = BsOrderColumn.desc;

          widget.controller.orders = [];
          _currentColumns.forEach((tempColumn) {
            tempColumn.orderState = BsOrderColumn(ordered: false);
          });

          column.orderState = BsOrderColumn(
            ordered: true,
            orderType: dir
          );

          widget.controller.orders.add({
            'column': column.columnData != null ? column.columnData! : _currentColumns.indexOf(column).toString(),
            'dir': dir
          });
          widget.controller.refresh();
        },
        child: column.build(context),
      ));
    });

    return _columns;
  }

  List<TableRow> get tableRows {
    List<TableRow> _tableRows = [];

    _tableRows.add(
      TableRow(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: widget.style.borderColor),
            bottom: BorderSide(color: widget.style.borderColor, width: 2),
          )
        ),
        children: columns
      )
    );

    for(int i = 0; i < widget.source.countDataPage; i++) {
      _tableRows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: widget.style.borderColor),
            )
          ),
          children: widget.source.getRow(i).cells
        )
      );
    }

    return _tableRows;
  }

  Widget table() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: Table(
                        columnWidths: columnsWidths,
                        children: tableRows,
                      ),
                    ),
                    _processing || widget.source.countDataPage > 0 ? Container() : Container(
                      width: constraints.maxWidth,
                      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: widget.style.borderColor),
                          )
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w100,
                            color: Color(0xff3e3e3e)
                        ),
                        child: widget.notFoundText != null ? widget.notFoundText! : Text('No data found', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                !_processing ? Container() : Container(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0, bottom: 15.0),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100,
                      color: Color(0xff3e3e3e)
                    ),
                    child: widget.processingText != null ? widget.processingText! : Text('Processing ...', textAlign: TextAlign.center),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget pagination() {
    List<Widget> _pagination = [];

    widget.paginations.forEach((pagination) {

      int currentPage = (widget.controller.start/widget.controller.length).round();
      int countPage = (widget.source.countData/widget.controller.length).ceil();
      if(widget.controller.searchValue != '')
        countPage = (widget.source.countFiltered/widget.controller.length).ceil();

      bool prevDisabled = widget.controller.start - widget.controller.length < 0;

      if(pagination == 'firstPage') {
        _pagination.add(BsPaginateButton(
          disabled: prevDisabled,
          margin: EdgeInsets.only(right: 5.0),
          label: widget.language.firstPagination,
          onPressed: prevDisabled ? null : () {
            widget.controller.start = 0;
            widget.controller.refresh();
          },
        ));
      }

      if(pagination == 'previous') {
        _pagination.add(BsPaginateButton(
          disabled: prevDisabled,
          margin: EdgeInsets.only(right: 5.0),
          label: widget.language.previousPagination,
          onPressed: prevDisabled ? null : () {
            if(widget.controller.start > widget.controller.length) {
              widget.controller.start = widget.controller.start - widget.controller.length;
              widget.controller.refresh();
            }
          },
        ));
      }

      if(pagination == 'button') {
        int start = 1;
        if(countPage < 4)
          start = 1;
        else if(currentPage + 4 >= countPage)
          start = countPage - 5;
        else if(currentPage >= 4)
          start = currentPage - 1;

        int end = 4;
        if(countPage < 4)
          end = countPage - 2;
        else if(currentPage + 4 >= countPage)
          end = countPage - 2;
        else if(currentPage >= 4)
          end = currentPage + 1;

        _pagination.add(BsPaginateButton(
          style: widget.stylePagination,
          active: currentPage + 1 == 1,
          margin: EdgeInsets.only(right: 5.0),
          label: '1',
          onPressed: () {
            widget.controller.start = 0;
            widget.controller.refresh();
          },
        ));

        if(currentPage >= 4) {
          _pagination.add(BsPaginateButton(
            style: widget.stylePagination,
            disabled: true,
            margin: EdgeInsets.only(right: 5.0),
            label: '...',
            onPressed: null,
          ));
        }

        if(countPage > 0) {
          for(int i = start; i <= end; i++) {
            _pagination.add(BsPaginateButton(
              style: widget.stylePagination,
              active: currentPage == i,
              margin: EdgeInsets.only(right: 5.0),
              label: '${i+1}',
              onPressed: () {
                widget.controller.start = i * widget.controller.length;
                widget.controller.refresh();
              },
            ));
          }
        }

        if(widget.controller.start/widget.controller.length + 4 < countPage) {
          _pagination.add(BsPaginateButton(
            style: widget.stylePagination,
            disabled: true,
            margin: EdgeInsets.only(right: 5.0),
            label: '...',
            onPressed: null,
          ));
        }

        if(countPage > 0) {
          _pagination.add(BsPaginateButton(
            style: widget.stylePagination,
            active: currentPage == countPage - 1,
            margin: EdgeInsets.only(right: 5.0),
            label: '$countPage',
            onPressed: () {
              widget.controller.start = (countPage - 1) * widget.controller.length;
              widget.controller.refresh();
            },
          ));
        }
      }

      if(pagination == 'input') {
        _pagination.add(Container(
          width: 50.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.style.borderColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          child: TextField(
            controller: _inputPage,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
              hintStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w100,
                  color: Colors.grey
              ),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
            onChanged: (value) => doneTyping(value, (value) {
              int page = int.parse(value);
              if(page <= 0 || value == '') {
                _inputPage.text = '1';
                widget.controller.start = 0;
                widget.controller.refresh();
              } else if(page > countPage) {
                _inputPage.text = countPage.toString();
                widget.controller.start = (countPage - 1) * widget.controller.length;
                widget.controller.refresh();
              } else {
                widget.controller.start = (page - 1) * widget.controller.length;
                widget.controller.refresh();
              }
            }),
          ),
        ));
      }

      bool nextDisabled = false;
      if(widget.controller.searchValue == '') {
        nextDisabled = widget.controller.start + widget.controller.length > widget.source.countData;
      } else if(widget.controller.searchValue != '') {
        nextDisabled = widget.controller.start + widget.controller.length > widget.source.countFiltered;
      }

      if(pagination == 'next') {
        _pagination.add(BsPaginateButton(
          disabled: nextDisabled,
          margin: EdgeInsets.only(left: 5.0),
          label: widget.language.nextPagination,
          onPressed: nextDisabled ? null : () {
            if(widget.controller.searchValue == ''
                && widget.controller.start + widget.source.countDataPage < widget.source.countData) {
              widget.controller.start = widget.controller.start + widget.controller.length;
              widget.controller.refresh();
            } else if(widget.controller.searchValue != ''
                && widget.controller.start + widget.source.countDataPage < widget.source.countFiltered) {
              widget.controller.start = widget.controller.start + widget.controller.length;
              widget.controller.refresh();
            }
          },
        ));
      }

      if(pagination == 'lastPage') {
        _pagination.add(BsPaginateButton(
          disabled: nextDisabled,
          margin: EdgeInsets.only(left: 5.0),
          label: widget.language.lastPagination,
          onPressed: nextDisabled ? null : () {
            if(widget.controller.searchValue == '') {
              widget.controller.start =
                  (widget.source.countData / widget.controller.length).ceil() *
                      widget.controller.length - widget.controller.length;
              widget.controller.refresh();
            } else if(widget.controller.searchValue != '') {
              widget.controller.start = (widget.source.countFiltered/widget.controller.length).ceil() * widget.controller.length - widget.controller.length;
              widget.controller.refresh();
            }
          },
        ));
      }
    });


    return Row(children: _pagination);
  }
}
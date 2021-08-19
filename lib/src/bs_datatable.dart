import 'dart:async';

import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:bs_flutter_utils/bs_flutter_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Type definition for customize datatable layout
/// in this function musth returned widget and this
/// function have [BsDatatable] state
typedef BsDatatableBuilder<T> = Widget Function(_BsDatatableState _);

typedef BsDatatableOnRowPressed<int, T> = Function(int i, List<BsDataCell> cells);

/// Widget class to create datatable configuration
class BsDatatable extends StatefulWidget {
  const BsDatatable({
    Key? key,
    required this.source,
    required this.columns,
    this.serverSide,
    this.customizeLayout,
    this.width,
    this.hintStyleSearch,
    this.title,
    this.titleTextStyle,
    this.pagination = BsPagination.buttons,
    this.notFoundText,
    this.processingText,
    this.textInfo,
    this.textInfoStyle,
    this.style = const BsDatatableStyle(),
    this.stylePagination = const BsPaginationButtonStyle(),
    this.language = const BsDatatableLanguage(),
    this.onRowPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BsDatatableState();
  }

  /// If you want to craete customize layout datatable, you can
  /// use [BsDatatableBuilder] class
  final BsDatatableBuilder? customizeLayout;

  /// Set width of [BsDatatable]
  final double? width;

  /// Set title of [BsDatatable]
  final Widget? title;

  /// Set title text style of [BsDatatable]
  final TextStyle? titleTextStyle;

  /// Pagination configuration for datatable
  /// if you want to hide [firstPage] and [lastPage] you can
  /// set pagination without [firstPage] and [lastPage]
  ///
  /// If you want to create numbered pagination use string value [input]
  /// if you want to create input pagination use string value [button]
  final List<BsPaginationButtons> pagination;

  /// Set not found text of [BsDatatable]
  final Widget? notFoundText;

  /// Set processing text of [BsDatatable]
  final Widget? processingText;

  /// Set hintStyleSearch of [BsDatatable]
  final TextStyle? hintStyleSearch;

  /// Set textInfo of [BsDatatable]
  final Widget? textInfo;

  /// Set textInfostyle of [BsDatatable]
  final TextStyle? textInfoStyle;

  /// Set columns of [BsDatatable]
  final List<BsDataColumn> columns;

  /// Set source of [BsDatatable]
  final BsDatatableSource source;

  /// Set serverSide of [BsDatatable]
  /// this properties must returned Future class
  /// [serverSide] properties is properties to get data
  /// from api server
  final BsDatatableServerSide? serverSide;

  /// Set language of [BsDatatable]
  final BsDatatableLanguage language;

  /// Set style of [BsDatatable]
  final BsDatatableStyle style;

  /// Set style of pagination button [BsDattable]
  final BsPaginationButtonStyle stylePagination;

  final BsDatatableOnRowPressed? onRowPressed;
}

class _BsDatatableState extends State<BsDatatable> {
  Timer? _timer;

  bool _processing = false;
  TextEditingController _inputSearch = TextEditingController();
  TextEditingController _inputLength = TextEditingController();
  TextEditingController _inputPage = TextEditingController(text: '1');

  late List<BsDataColumn> _currentColumns;

  Map<int, bool> _isHover = Map<int, bool>();

  @override
  void initState() {
    init();
    super.initState();
  }

  void _updateState(VoidCallback function) {
    if (mounted) setState(() => function());
  }

  void init() {
    widget.source.controller.onReloadListener((load) {
      if (load && widget.serverSide != null) {
        _updateState(() => _processing = true);

        widget.serverSide!(widget.source.controller.toJson()).then((value) {
          widget.source.reload();
          _updateState(() {
            _processing = false;
            widget.source.controller.draw++;
            _inputPage.text = ((widget.source.controller.start / widget.source.controller.length).ceil() + 1).toString();
          });
        });
      } else {
        widget.source.reload();
        _updateState(() { });
      }
    });

    _currentColumns = List<BsDataColumn>.from(widget.columns);
    _inputLength.text = widget.source.controller.length.toString();

    widget.source.controller.columns = [];
    _currentColumns.forEach((column) {
      String index = _currentColumns.indexOf(column).toString();

      String columnData = '';
      if (column.columnData == null && column.columnName != null)
        columnData = column.columnName!;
      else if (column.columnData == null && column.columnName == null)
        columnData = index;
      else if (column.columnData != null) columnData = column.columnData!;

      widget.source.controller.columns.add({
        'data': columnData,
        'name': column.columnName != null ? column.columnName! : '',
        'orderable': column.orderable.toString(),
        'searchable': column.searchable.toString(),
        'searchvalue': column.searchValue,
        'searchregex': column.searchRegex
      });

      if (column.orderState.ordered) {
        widget.source.controller.orders = [];
        widget.source.controller.orders.add({
          'column': index,
          'dir': column.orderState.orderType,
        });
      }

      if (widget.source.controller.orders.length == 0 && column.orderable) {
        widget.source.controller.orders = [];
        column.orderState =
            BsOrderColumn(ordered: true, orderType: BsOrderColumn.asc);
        widget.source.controller.orders.add({
          'column': columnData,
          'dir': column.orderState.orderType,
        });
      }
    });

    widget.source.controller.reload();
  }

  void _doneTyping(dynamic value, ValueChanged<dynamic> callback) {
    if (_timer != null) _timer!.cancel();

    _timer = Timer(Duration(milliseconds: 500), () => callback(value));
  }

  String _replaceText(String text) {
    String start = text.replaceAll(
        '__START__',
        ((widget.source.controller.searchValue == '' &&
                        widget.source.countData > 0) ||
                    (widget.source.controller.searchValue != '' &&
                        widget.source.countFiltered > 0)
                ? widget.source.controller.start + 1
                : 0)
            .toString());
    String end = start.replaceAll(
        '__END__',
        (widget.source.controller.start + widget.source.countDataPage)
            .toString());
    String data =
        end.replaceAll('__DATA__', widget.source.countData.toString());
    String filtered =
        data.replaceAll('__FILTERED__', widget.source.countFiltered.toString());

    return filtered;
  }

  Map<int, TableColumnWidth> _getColumnsWidths(BuildContext context) {
    Map<int, TableColumnWidth> _columnsWidths = Map<int, TableColumnWidth>();

    _currentColumns.forEach((column) {
      if (column.width != null)
        _columnsWidths.addAll(
            {_currentColumns.indexOf(column): FixedColumnWidth(column.width!)});
      else if ([BreakPoint.stateXs, BreakPoint.stateSm, BreakPoint.stateMd]
          .contains(BreakPoint.of(context).state))
        _columnsWidths
            .addAll({_currentColumns.indexOf(column): FixedColumnWidth(300.0)});
    });

    return _columnsWidths;
  }

  List<Widget> _getColumns() {
    List<Widget> _columns = [];

    _currentColumns.forEach((column) {
      _columns.add(TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(double.infinity, 10.0),
        ),
        onPressed: column.orderable == false
            ? null
            : () {
                String dir = BsOrderColumn.def;

                if (column.orderState.orderType == BsOrderColumn.def ||
                    column.orderState.orderType == BsOrderColumn.desc)
                  dir = BsOrderColumn.asc;
                else if (column.orderState.orderType == BsOrderColumn.asc)
                  dir = BsOrderColumn.desc;

                widget.source.controller.orders = [];
                _currentColumns.forEach((tempColumn) =>
                    tempColumn.orderState = BsOrderColumn(ordered: false));

                column.orderState =
                    BsOrderColumn(ordered: true, orderType: dir);

                widget.source.controller.orders.add({
                  'column': _currentColumns.indexOf(column).toString(),
                  'dir': dir
                });
                widget.source.controller.reload();
              },
        child: column.build(context),
      ));
    });

    return _columns;
  }

  List<TableRow> _getRows() {
    List<TableRow> _tableRows = [];

    _tableRows.add(TableRow(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: widget.style.borderColor),
          bottom: BorderSide(color: widget.style.borderColor, width: 2),
        )),
        children: _getColumns()));

    for (int i = 0; i < widget.source.countDataPage; i++) {
      if (!_isHover.containsKey(i)) _isHover[i] = false;

      List<BsDataCell> cells = widget.source.getRow(i).getCells();
      List<Widget> children = List<Widget>.from([]);
      cells.forEach((cell) {
        children.add(Material(
          color: Colors.transparent,
          child: InkWell(
            child: cell,
            onTap: widget.onRowPressed == null
                ? null
                : () {
                    if (widget.onRowPressed != null)
                      widget.onRowPressed!(i, cells);
                  },
            onHover: (value) {
              _updateState(() {
                _isHover[i] = value;
              });
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
          ),
        ));
      });

      Color backgroundColor =
          i % 2 == 0 ? Colors.transparent : widget.style.color;

      _tableRows.add(TableRow(
          decoration: BoxDecoration(
              color: _isHover[i]! ? widget.style.hoverColor : backgroundColor,
              border: Border(
                bottom: BorderSide(color: widget.style.borderColor),
              )),
          children: children));
    }

    return _tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return widget.customizeLayout != null
        ? widget.customizeLayout!(this)
        : Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: header(),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Row(children: [Expanded(child: table())]),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: footer(),
                ),
              ],
            ),
          );
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
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: Table(
                        columnWidths: _getColumnsWidths(context),
                        children: _getRows(),
                      ),
                    ),
                    _processing || widget.source.countDataPage > 0
                        ? Container()
                        : Container(
                            width: constraints.maxWidth,
                            padding:
                                EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 15.0),
                            decoration: BoxDecoration(
                                border: Border(
                              bottom:
                                  BorderSide(color: widget.style.borderColor),
                            )),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .fontSize,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w100,
                                  color: Color(0xff3e3e3e)),
                              child: widget.notFoundText != null
                                  ? widget.notFoundText!
                                  : Text('No data found',
                                      textAlign: TextAlign.center),
                            ),
                          ),
                  ],
                ),
                !_processing
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 15.0, bottom: 15.0),
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .fontSize,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w100,
                              color: Color(0xff3e3e3e)),
                          child: widget.processingText != null
                              ? widget.processingText!
                              : Text('Processing ...',
                                  textAlign: TextAlign.center),
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget informationData() {
    String text = _replaceText(widget.language.information);
    if (widget.source.controller.searchValue != '')
      text = _replaceText(
          '${widget.language.information} (${widget.language.informationFiltered})');

    return widget.textInfo != null
        ? widget.textInfo!
        : Text(text,
            style: TextStyle(fontSize: 12.0).merge(widget.textInfoStyle));
  }

  Widget title() {
    return DefaultTextStyle(
        style: TextStyle(fontSize: 18.0, color: Colors.black)
            .merge(widget.titleTextStyle),
        child: widget.title != null ? widget.title! : Container());
  }

  Widget pageLength() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.language.perPageLabel == null
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 2.0),
                child: Text(widget.language.perPageLabel!,
                    style: TextStyle(fontSize: 10.0)),
              ),
        Container(
          width: 60.0,
          margin: EdgeInsets.only(right: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.style.borderColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: TextField(
            controller: _inputLength,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100,
                  color: Colors.grey),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _doneTyping(value, (value) {
              if (value == '' || int.parse(value) <= 0) {
                widget.source.controller.start = 0;
                widget.source.controller.length = 10;
                _inputLength.text = '10';
                widget.source.controller.reload();
              } else {
                int length = int.parse(value);

                widget.source.controller.start = 0;
                widget.source.controller.length = length;
                widget.source.controller.reload();
              }
            }),
          ),
        )
      ],
    );
  }

  Widget searchForm({double width = 250}) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.language.searchLabel == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(bottom: 2.0),
                  child: Text(widget.language.searchLabel!,
                      style: TextStyle(fontSize: 10.0)),
                ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: widget.style.borderColor),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: TextField(
              controller: _inputSearch,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                hintText: widget.language.hintTextSearch,
                hintStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey)
                    .merge(widget.hintStyleSearch),
                isDense: true,
              ),
              onChanged: (value) => _doneTyping(value, (value) {
                widget.source.controller.searchValue = value;
                widget.source.controller.start = 0;
                widget.source.controller.reload();
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget pagination() {
    List<Widget> _pagination = [];

    int currentPage =
        (widget.source.controller.start / widget.source.controller.length)
            .round();
    int countPage =
        (widget.source.countData / widget.source.controller.length).ceil();
    if (widget.source.controller.searchValue != '')
      countPage =
          (widget.source.countFiltered / widget.source.controller.length)
              .ceil();

    bool prevDisabled = currentPage < 1;
    bool disabledNext = currentPage >= countPage - 1;

    /// Variable initial number of button pagination
    int start = 1;

    if (currentPage < 4 || (currentPage == countPage - 1 && countPage <= 5))
      start = 1;
    else if (currentPage + 4 > countPage)
      start = countPage - 5;
    else if (currentPage >= 4) start = currentPage - 1;

    /// Variable end number of button pagination
    int end = 4;

    if (currentPage < 4 && countPage > 5)
      end = 4;
    else if (currentPage + 4 >= countPage || countPage <= 5)
      end = countPage - 2;
    else if (currentPage >= 4) end = currentPage + 1;

    widget.pagination.forEach((pagination) {
      if (pagination == BsPaginationButtons.firstPage) {
        _pagination.add(BsPaginationButton(
          disabled: prevDisabled,
          margin: EdgeInsets.only(right: 5.0),
          label: widget.language.firstPagination,
          onPressed: prevDisabled
              ? null
              : () {
                  widget.source.controller.start = 0;
                  widget.source.controller.reload();
                },
        ));
      }

      if (pagination == BsPaginationButtons.previous) {
        _pagination.add(BsPaginationButton(
          disabled: prevDisabled,
          margin: EdgeInsets.only(right: 5.0),
          label: widget.language.previousPagination,
          onPressed: prevDisabled
              ? null
              : () {
                  widget.source.controller.start =
                      widget.source.controller.start -
                          widget.source.controller.length;
                  widget.source.controller.reload();
                },
        ));
      }

      if (pagination == BsPaginationButtons.button) {
        /// Added pagination button for first page
        /// This button will always appear even though the number
        /// of pages is only 1
        _pagination.add(BsPaginationButton(
          style: widget.stylePagination,
          active: currentPage + 1 == 1,
          margin: EdgeInsets.only(right: 5.0),
          label: '1',
          onPressed: () {
            widget.source.controller.start = 0;
            widget.source.controller.reload();
          },
        ));

        /// When the current page is more than equal 4
        /// separator button for responsive pagination will be
        /// show before numbered pagination button
        if (currentPage >= 4 && countPage > 5) {
          _pagination.add(BsPaginationButton(
            style: widget.stylePagination,
            disabled: true,
            margin: EdgeInsets.only(right: 5.0),
            label: '...',
            onPressed: null,
          ));
        }

        /// When the countPage is more than zero, the numbered pagination button will
        /// display according to the specified start and end limits
        if (countPage > 0) {
          for (int i = start; i <= end; i++) {
            _pagination.add(BsPaginationButton(
              style: widget.stylePagination,
              active: currentPage == i,
              margin: EdgeInsets.only(right: 5.0),
              label: '${i + 1}',
              onPressed: () {
                widget.source.controller.start =
                    i * widget.source.controller.length;
                widget.source.controller.reload();
              },
            ));
          }
        }

        /// When currentPage + 5 is more than countPage
        /// separator button for responsive pagination will be
        /// show after numbered pagination button
        if (currentPage + 4 < countPage && countPage > 5) {
          _pagination.add(BsPaginationButton(
            style: widget.stylePagination,
            disabled: true,
            margin: EdgeInsets.only(right: 5.0),
            label: '...',
            onPressed: null,
          ));
        }

        /// When the countPage is more than 1
        /// at the last of numbered pagination button will show
        /// countPage button
        if (countPage > 1) {
          _pagination.add(BsPaginationButton(
            style: widget.stylePagination,
            active: currentPage == countPage - 1,
            margin: EdgeInsets.only(right: 5.0),
            label: '$countPage',
            onPressed: () {
              widget.source.controller.start =
                  (countPage - 1) * widget.source.controller.length;
              widget.source.controller.reload();
            },
          ));
        }
      }

      if (pagination == BsPaginationButtons.input) {
        _pagination.add(Container(
          width: 50.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.style.borderColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: TextField(
            controller: _inputPage,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
              hintStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w100,
                  color: Colors.grey),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
            onChanged: (value) => _doneTyping(value, (value) {
              int page = int.parse(value);
              if (page <= 0 || value == '') {
                _inputPage.text = '1';
                widget.source.controller.start = 0;
                widget.source.controller.reload();
              } else if (page > countPage) {
                _inputPage.text = countPage.toString();
                widget.source.controller.start =
                    (countPage - 1) * widget.source.controller.length;
                widget.source.controller.reload();
              } else {
                widget.source.controller.start =
                    (page - 1) * widget.source.controller.length;
                widget.source.controller.reload();
              }
            }),
          ),
        ));
      }

      if (pagination == BsPaginationButtons.next) {
        _pagination.add(BsPaginationButton(
          disabled: disabledNext,
          margin: EdgeInsets.only(left: 5.0),
          label: widget.language.nextPagination,
          onPressed: disabledNext
              ? null
              : () {
                  widget.source.controller.start =
                      widget.source.controller.start +
                          widget.source.controller.length;
                  widget.source.controller.reload();
                },
        ));
      }

      if (pagination == BsPaginationButtons.lastPage) {
        _pagination.add(BsPaginationButton(
          disabled: disabledNext,
          margin: EdgeInsets.only(left: 5.0),
          label: widget.language.lastPagination,
          onPressed: disabledNext
              ? null
              : () {
                  widget.source.controller.start =
                      countPage * widget.source.controller.length -
                          widget.source.controller.length;
                  widget.source.controller.reload();
                },
        ));
      }
    });

    return Row(children: _pagination);
  }

  Widget header() {
    bool isMobile = [BreakPoint.stateXs, BreakPoint.stateSm]
        .contains(BreakPoint.of(context).state);

    return isMobile ? _headerSmallDevice() : _headerLargeDevice();
  }

  Widget _headerLargeDevice() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title(),
          Container(
            width: 500,
            child: Row(
              children: [
                pageLength(),
                Expanded(
                    child: LayoutBuilder(
                  builder: (context, constraints) =>
                      searchForm(width: constraints.maxWidth),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _headerSmallDevice() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: title(),
          ),
          Row(
            children: [
              Expanded(child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    child: Row(
                      children: [
                        pageLength(),
                        Expanded(
                            child: LayoutBuilder(
                          builder: (context, constraints) =>
                              searchForm(width: constraints.maxWidth),
                        ))
                      ],
                    ),
                  );
                },
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget footer() {
    bool isMobile = [BreakPoint.stateXs, BreakPoint.stateSm]
        .contains(BreakPoint.of(context).state);

    return !isMobile ? _footerLargeDevice() : _footerSmallDevice();
  }

  Widget _footerLargeDevice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        informationData(),
        pagination(),
      ],
    );
  }

  Widget _footerSmallDevice() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                informationData(),
              ],
            ),
          ),
          Scrollbar(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: pagination(),
          ))
        ],
      ),
    );
  }
}

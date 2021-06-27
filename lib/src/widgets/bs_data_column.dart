import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:flutter/material.dart';

class BsDataColumn extends StatelessWidget {
  BsDataColumn(
      {Key? key,
      this.width,
      this.height = 20.0,
      this.alignment,
      this.padding = const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 15.0, bottom: 15.0),
      this.textStyle,
      this.border,
      this.orderable = true,
      this.searchable = true,
      this.searchValue = '',
      this.searchRegex = 'false',
      this.columnName,
      this.columnData,
      this.orderState = const BsOrderColumn(),
      required this.label})
      : super(key: key);

  final Widget label;

  final double? width;

  final double height;

  final AlignmentGeometry? alignment;

  final EdgeInsetsGeometry padding;

  final TextStyle? textStyle;

  final BoxBorder? border;

  final bool orderable;

  final bool searchable;

  final String searchValue;

  final String searchRegex;

  BsOrderColumn orderState;

  final String? columnName;

  final String? columnData;

  Widget orderIcon(BuildContext context) {
    Widget icon = Container();
    icon = Stack(
      children: [
        Positioned(
            child: Container(
                child: Icon(
          Icons.arrow_drop_up,
          color:
              (orderState.ordered && orderState.orderType == BsOrderColumn.asc
                      ? Colors.black
                      : Colors.grey)
                  .withOpacity(orderable ? 0.8 : 0),
          size: Theme.of(context).textTheme.bodyText1!.fontSize! + 5.0,
        ))),
        Positioned(
            child: Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: (orderState.ordered &&
                              orderState.orderType == BsOrderColumn.desc
                          ? Colors.black
                          : Colors.grey)
                      .withOpacity(orderable ? 0.8 : 0),
                  size: Theme.of(context).textTheme.bodyText1!.fontSize! + 5.0,
                ))),
      ],
    );

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          Expanded(
              child: Container(
            alignment: alignment,
            padding: padding,
            decoration: BoxDecoration(
                border: border != null
                    ? border!
                    : Border(
                        top: BorderSide(color: Color(0xffdedede)),
                        bottom:
                            BorderSide(color: Color(0xffdedede), width: 2.0),
                      )),
            child: DefaultTextStyle(
              style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold)
                  .merge(textStyle),
              child:
                  Row(children: [Expanded(child: label), orderIcon(context)]),
            ),
          )),
        ],
      ),
    );
  }
}

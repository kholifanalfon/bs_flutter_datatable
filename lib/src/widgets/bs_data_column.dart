import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BsDataColumn extends StatelessWidget {
  BsDataColumn({
    Key? key,
    this.width,
    this.height = 20.0,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 15.0),
    this.textStyle,
    this.border,
    this.orderable = true,
    this.searchable = true,
    this.searchValue = '',
    this.searchRegex = 'false',
    this.columnName,
    this.columnData,
    this.orderState = const BsOrderColumn(),
    required this.label,
  }) : super(key: key);

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
              color: (orderState.ordered &&
                          orderState.orderType == BsOrderColumn.asc
                      ? Colors.black
                      : Colors.grey)
                  .withOpacity(orderable ? 0.8 : 0),
              size: Theme.of(context).textTheme.bodyText1!.fontSize! + 5.0,
            ),
          ),
        ),
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
            ),
          ),
        ),
      ],
    );

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              alignment: alignment,
              padding: padding,
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ).merge(textStyle),
                child: Row(
                  children: [
                    Expanded(child: label),
                    orderIcon(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BsDataCell extends StatelessWidget {
  const BsDataCell(
    this.child, {
    Key? key,
    this.padding = const EdgeInsets.all(15.0),
    this.alignment,
  }) : super(key: key);

  final Widget child;

  final EdgeInsets padding;

  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment,
      child: Row(
        children: [
          Expanded(child: Container(child: child))
        ],
      ),
    );
  }
}

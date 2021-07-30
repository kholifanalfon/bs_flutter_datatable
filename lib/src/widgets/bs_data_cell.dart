import 'package:flutter/material.dart';

class BsDataCell extends StatelessWidget {
  const BsDataCell(
    this.child, {
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(child: Container(child: child))
        ],
      ),
    );
  }
}

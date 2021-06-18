import 'package:flutter/material.dart';

class BsDataColumn extends StatelessWidget {

  const BsDataColumn({
    Key? key,
    required this.label
  }) : super(key: key);

  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: TextStyle(
        color:Colors.grey,
        fontSize: 12.0
      ),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xffdedede)),
            bottom: BorderSide(color: Color(0xffdedede)),
          )
        ),
        child: label,
      ),
    );
  }

}
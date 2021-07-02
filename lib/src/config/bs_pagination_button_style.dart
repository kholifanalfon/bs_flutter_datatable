import 'package:flutter/material.dart';

class BsPaginationButtonStyle {
  const BsPaginationButtonStyle({
    this.textStyle = const TextStyle(),
    this.textStyleActive = const TextStyle(color: Colors.white),
    this.minimumSize = const Size(20.0, 20.0),
    this.padding =
    const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0, bottom: 6.0),
    this.decoration = const BoxDecoration(),
    this.activeDecoration = const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(Radius.circular(50.0))),
  });

  final TextStyle textStyle;

  final TextStyle textStyleActive;

  final Size minimumSize;

  final EdgeInsets padding;

  final BoxDecoration decoration;

  final BoxDecoration activeDecoration;
}
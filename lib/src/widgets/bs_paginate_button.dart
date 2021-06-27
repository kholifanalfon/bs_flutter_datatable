import 'package:flutter/material.dart';

class BsPaginateButtonStyle {
  const BsPaginateButtonStyle({
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

class BsPaginateButton extends StatelessWidget {
  const BsPaginateButton({
    Key? key,
    this.disabled = false,
    this.active = false,
    this.onPressed,
    this.margin,
    this.style = const BsPaginateButtonStyle(),
    required this.label,
  }) : super(key: key);

  final VoidCallback? onPressed;

  final bool disabled;

  final bool active;

  final EdgeInsetsGeometry? margin;

  final String label;

  final BsPaginateButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: style.minimumSize,
        ),
        onPressed: onPressed,
        child: Container(
          padding: style.padding,
          decoration: active ? style.activeDecoration : style.decoration,
          child: Text(label,
              style: TextStyle(
                      fontSize: 12.0,
                      color: disabled
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodyText1!.color)
                  .merge(active ? style.textStyleActive : style.textStyle)),
        ),
      ),
    );
  }
}

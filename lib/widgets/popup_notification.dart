import 'package:flutter/material.dart';

import 'package:cat_app/styles/styles.dart';

class PopupNotification extends StatelessWidget {
  final String text;
  final onPressed;
  final double radius;

  const PopupNotification(this.text, {this.onPressed, Key key, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Text("Dialog!"),
      ],
    );
  }
}
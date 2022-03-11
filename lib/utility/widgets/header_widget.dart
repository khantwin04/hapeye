import 'package:flutter/material.dart';

Widget HeaderWidget(String text) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 5.0),
    child: Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 18),
    ),
  );
}

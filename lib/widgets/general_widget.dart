import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildSubtitleTwo(BuildContext context, String s) {
  return RichText(
      text: TextSpan(
          text: s,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: Colors.grey)));
}

Widget buildContentText(BuildContext context, String s) {
  return RichText(
      text: TextSpan(
          text: s,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black)));
}

Widget buildLinearProgressBar(BuildContext context) {
  return LinearProgressIndicator(
    backgroundColor: Colors.grey,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
  );
}

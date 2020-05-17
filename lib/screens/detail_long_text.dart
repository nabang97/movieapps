import 'package:flutter/material.dart';

class DetailLongText extends StatelessWidget {
  final String text;

  const DetailLongText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(child: Text(text)),
    );
  }
}

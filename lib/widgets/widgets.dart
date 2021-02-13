import 'package:anxi_pro/color_scheme.dart';
import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(
            text: 'Mind',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: ppurple)),
        TextSpan(
            text: ' Journal',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    ),
  );
}

Widget purpleButton(BuildContext context, String label) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        color: Colors.deepPurple, borderRadius: BorderRadius.circular(30)),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
  );
}

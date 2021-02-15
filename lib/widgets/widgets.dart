import 'package:anxi_pro/color_scheme.dart';
import 'package:anxi_pro/services/auth.dart';
import 'package:flutter/material.dart';

Widget appBar(BuildContext context, bool showSignout) {
  AuthService authService = new AuthService();
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 22),
        children: <TextSpan>[
          TextSpan(text: 'Mind', style: TextStyle(fontWeight: FontWeight.w600, color: ppurple)),
          TextSpan(text: ' Journal', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
        ],
      ),
    ),
    (showSignout)
        ? GestureDetector(
            child: Icon(Icons.logout),
            onTap: () {
              authService.signOut();
              Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
            },
          )
        : Container(),
  ]);
}

Widget purpleButton(BuildContext context, String label) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
  );
}

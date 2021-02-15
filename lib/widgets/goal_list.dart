import 'package:anxi_pro/color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget goal_list(width) {
  return Container(
      child: Stack(children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "My Mental Goals",
              style: TextStyle(color: dark_purple, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.add_box_rounded,
              color: okay_green,
              size: 30,
            )
          ]),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.circle_lefthalf_fill,
                color: okay_green,
                size: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "I want to be more patient with myself and others.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.circle,
                color: okay_green,
                size: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "I want to be slower to anger.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    )
  ]));
}

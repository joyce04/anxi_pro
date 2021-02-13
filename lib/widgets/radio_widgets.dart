import 'package:anxi_pro/models/question.dart';
import 'package:flutter/material.dart';

class RadioTile extends StatefulWidget {
  RadioTile({this.option, this.val, this.desc, this.onPressed});

  String option, desc, val;
  bool selected = false;
  VoidCallback onPressed;
  _RadioTileState _state;

  update() {
    _state.setState(() {});
  }

  @override
  _RadioTileState createState() => _RadioTileState();
}

class _RadioTileState extends State<RadioTile> {
  @override
  Widget build(BuildContext context) {
    widget._state = this;

    return GestureDetector(
        // onTap: widget.onPressed,
        onTap: () {
          widget.onPressed();
          widget.update();
        },
        child: Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2.5,
                          color: widget.selected
                              ? Color(0xff7a4988)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.option}",
                    style: TextStyle(
                        color: widget.selected
                            ? Color(0xff311432)
                            : Colors.black54,
                        fontWeight: widget.selected
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  widget.desc,
                  style: TextStyle(
                      fontSize: 16,
                      color:
                          widget.selected ? Color(0xff311432) : Colors.black54),
                )
              ],
            )));
  }
}

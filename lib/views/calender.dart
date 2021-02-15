import 'dart:ffi';

import 'package:anxi_pro/color_scheme.dart';
import 'package:anxi_pro/models/mood.dart';
import 'package:anxi_pro/services/auth.dart';
import 'package:anxi_pro/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  AuthService authService = new AuthService();
  DatabaseService dbService = new DatabaseService();
  QuerySnapshot moodsSnapshot;
  DateTime _selectedDate = new DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _onDaySelected(_selectedDate, null, null);
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarController: _calendarController,
          initialCalendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.monday,
          formatAnimation: FormatAnimation.slide,
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonVisible: false,
            leftChevronMargin: EdgeInsets.only(left: 70),
            rightChevronMargin: EdgeInsets.only(right: 70),
          ),
          calendarStyle: CalendarStyle(
            weekendStyle: TextStyle(color: dark_orange),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(color: dark_orange),
          ),
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: _onVisibleDaysChanged,
        ),
        SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  DateFormat.yMMMMd().format(_selectedDate).toString(),
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (moodsSnapshot == null || moodsSnapshot.docs.length == 0)
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: moodsSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        return EmotionTile(
                          mood: convertFromDocumentSnapShot(moodsSnapshot.docs[index]),
                        );
                      })
            ],
          ),
        )
      ],
    );
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    _selectedDate = day;
    dbService.getMoods(authService.getCurrentUserUid(), day).then((val) {
      setState(() {
        moodsSnapshot = val;
      });
      print(val);
      if (val != null) {
        print(val.docs.length);
      }
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('visible daay changed');
    if (last.compareTo(_selectedDate) < 0) {
      _onDaySelected(last, null, null);
    } else {
      _onDaySelected(first, null, null);
    }
  }
}

class EmotionTile extends StatelessWidget {
  final Mood mood;

  EmotionTile({@required this.mood});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5, right: 10),
                width: MediaQuery.of(context).size.width * 0.17,
                child: Text(
                  mood.getHourMin(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, right: 10),
                height: 50,
                width: 50,
                decoration: feelingDecoration(mood.feeling),
              ),
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width * .7,
              decoration: BoxDecoration(color: purple_3),
              padding: EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  (mood.feelingDetail == null) ? '' : mood.feelingDetail,
                  style: TextStyle(color: purple, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      mood.oneLine,
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 3,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Icon(
                      Icons.category_rounded,
                      color: purple,
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          mood.causes.join(', '),
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ])),
        ],
      ),
      SizedBox(
        height: 15,
      )
    ]);
  }

  BoxDecoration feelingDecoration(String feeling) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      image: DecorationImage(
        colorFilter: new ColorFilter.mode(iconColors[feeling], BlendMode.dstATop),
        image: AssetImage('asset/image/' + iconImgs[feeling]),
      ),
    );
  }
}

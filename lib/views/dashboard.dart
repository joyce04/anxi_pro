import 'dart:math';

import 'package:anxi_pro/services/database.dart';
import 'package:anxi_pro/views/save_survey.dart';
import 'package:anxi_pro/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'check_my_state.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Stream surveyStream;
  DatabaseService dbService = new DatabaseService();
  List<Color> tileColors = [
    Color(0xff7f58af),
    Color(0xff64c5eb),
    Color(0xffb65fcf),
    Color(0xffd6d1f5),
    Color(0xff7a4988)
  ];

  Color randomlyChooseColor() {
    final random = new Random();
    return tileColors[random.nextInt(tileColors.length)];
  }

  Widget surveyList() {
    return Container(
      child: StreamBuilder(
        stream: surveyStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return SurveyTile(
                        surveyId: snapshot.data.docs[index].id,
                        backgroundColor: randomlyChooseColor(),
                        title: snapshot.data.docs[index]['title'],
                        desc: snapshot.data.docs[index]['desc']);
                  });
        },
      ),
    );
  }

  @override
  void initState() {
    dbService.getSurveys().then((val) {
      setState(() {
        surveyStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.dark,
      ),
      body: surveyList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CheckMyState()));
        },
      ),
    );
  }
}

class SurveyTile extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String desc;
  final surveyId;

  SurveyTile(
      {@required this.surveyId,
      @required this.backgroundColor,
      @required this.title,
      this.desc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SaveSurvey(surveyId)));
        },
        child: Container(
            margin: EdgeInsets.only(right: 24, left: 24, bottom: 8),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(30)),
            height: 80,
            width: MediaQuery.of(context).size.width - 48,
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 4,
                        ),
                        Text(desc,
                            style: TextStyle(color: Colors.white, fontSize: 14))
                      ],
                    ))
              ],
            )));
  }
}

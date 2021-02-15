import 'dart:math';

import 'package:anxi_pro/services/database.dart';
import 'package:anxi_pro/views/save_survey.dart';
import 'package:anxi_pro/widgets/goal_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:anxi_pro/color_scheme.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Stream surveyStream;
  DatabaseService dbService = new DatabaseService();
  List<Color> tileColors = [purple, orange, purple_2, pink_2, purple_3, purple_4];
  String selectedType = 'initial';
  String selectedFrequency = 'daily';

  Color randomlyChooseColor() {
    final random = new Random();
    return tileColors[random.nextInt(tileColors.length)];
  }

  Widget surveyList() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Choose survey type you want to record", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      SizedBox(
        height: 30,
      ),
      StreamBuilder(
        stream: surveyStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
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
    ]));
  }

  @override
  void initState() {
    dbService.getSurveys().then((val) {
      setState(() {
        surveyStream = val;
      });
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        goal_list(MediaQuery.of(context).size.width * 0.8),
        SizedBox(
          height: 30,
        ),
        Text(
          'Select Notification Frequency',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  changeFrequency("Q4H");
                },
                child: Container(
                    height: 50,
                    width: 110,
                    decoration: (selectedFrequency == 'Q4H')
                        ? BoxDecoration(color: orange, borderRadius: BorderRadius.all(Radius.circular(10)))
                        : BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black.withOpacity(0.3)),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Text("Q4H",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: (selectedFrequency == 'Q4H') ? Colors.white : Colors.black))))),
            InkWell(
                onTap: () {
                  changeFrequency("daily");
                },
                child: Container(
                    height: 50,
                    width: 110,
                    decoration: (selectedFrequency == 'daily')
                        ? BoxDecoration(color: orange, borderRadius: BorderRadius.all(Radius.circular(10)))
                        : BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black.withOpacity(0.3)),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Text("Daily",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: (selectedFrequency == 'daily') ? Colors.white : Colors.black))))),
            InkWell(
                onTap: () {
                  changeFrequency("weekly");
                },
                child: Container(
                    height: 50,
                    width: 110,
                    decoration: (selectedFrequency == 'weekly')
                        ? BoxDecoration(color: orange, borderRadius: BorderRadius.all(Radius.circular(10)))
                        : BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black.withOpacity(0.3)),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Text("Weekly",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: (selectedFrequency == 'weekly') ? Colors.white : Colors.black)))))
          ],
        ),
        SizedBox(
          height: 30,
        ),
        surveyList(),
      ],
    );
  }

  void changeSelectedType(String type) {
    selectedType = type;
    setState(() {});
  }

  void changeFrequency(String frequency) {
    selectedFrequency = frequency;
    setState(() {});
  }
}

class SurveyTile extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String desc;
  final surveyId;

  SurveyTile({@required this.surveyId, @required this.backgroundColor, @required this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SaveSurvey(surveyId)));
        },
        child: Container(
            margin: EdgeInsets.only(right: 4, left: 4, bottom: 8),
            decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(30)),
            height: 80,
            width: MediaQuery.of(context).size.width - 48,
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 4,
                        ),
                        Text(desc, style: TextStyle(color: Colors.white, fontSize: 14))
                      ],
                    ))
              ],
            )));
  }
}

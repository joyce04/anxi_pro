import 'package:anxi_pro/color_scheme.dart';
import 'package:anxi_pro/color_scheme.dart';
import 'package:anxi_pro/services/database.dart';
import 'package:anxi_pro/views/dashboard.dart';
import 'package:anxi_pro/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class RecordMyState extends StatefulWidget {
  @override
  _RecordMyStateState createState() => _RecordMyStateState();
}

class _RecordMyStateState extends State<RecordMyState> {
  String mood, oneLine;
  String feeling = 'bad';
  DatabaseService dbservice = new DatabaseService();
  List<String> selectedCauses = [];

  bool _isLoading = false;

  createMood() async {
    setState(() {
      _isLoading = true;
    });
    String moodId = randomAlphaNumeric(4) + '_' + DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, String> moodMap = {
      'moodId': moodId,
      'mood': mood,
      'oneLine': oneLine,
      'feeling': feeling,
      'causes': selectedCauses.join(",")
    };
    await dbservice.addMood(moodMap, moodId).then((val) {
      setState(() {
        _isLoading = false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
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
          iconTheme: IconThemeData(color: Colors.black87),
          brightness: Brightness.dark,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
                child: Expanded(
                    child: _isLoading
                        ? Container(child: Center(child: CircularProgressIndicator()))
                        : Container(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("How do you feel?", style: TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        changeFeeling("very_bad");
                                      },
                                      child: Column(children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: (feeling == 'very_bad')
                                                ? Border.all(color: orange.withOpacity(0.3), width: 4)
                                                : Border.all(color: Colors.black26.withOpacity(0.3), width: 4),
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                            image: DecorationImage(
                                              colorFilter: new ColorFilter.mode(purple, BlendMode.dstATop),
                                              image: AssetImage('asset/image/bt_verybad.png'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("very_bad",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: (feeling == 'very_bad') ? dark_orange : Colors.black))
                                      ])),
                                  InkWell(
                                      onTap: () {
                                        changeFeeling("bad");
                                      },
                                      child: Column(children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: (feeling == 'bad')
                                                ? Border.all(color: orange.withOpacity(0.3), width: 4)
                                                : Border.all(color: Colors.black26.withOpacity(0.3), width: 4),
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                            image: DecorationImage(
                                              colorFilter: new ColorFilter.mode(purple, BlendMode.dstATop),
                                              image: AssetImage('asset/image/bt_bad.png'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("bad",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: (feeling == 'bad') ? dark_orange : Colors.black))
                                      ])),
                                  InkWell(
                                      onTap: () {
                                        changeFeeling("neutral");
                                      },
                                      child: Column(children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: (feeling == 'neutral')
                                                ? Border.all(color: orange.withOpacity(0.3), width: 4)
                                                : Border.all(color: Colors.black26.withOpacity(0.3), width: 4),
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                            image: DecorationImage(
                                              colorFilter: new ColorFilter.mode(purple, BlendMode.dstATop),
                                              image: AssetImage('asset/image/bt_neutral.png'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("neutral",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: (feeling == 'neutral') ? dark_orange : Colors.black))
                                      ])),
                                  InkWell(
                                      onTap: () {
                                        changeFeeling("good");
                                      },
                                      child: Column(children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: (feeling == 'good')
                                                ? Border.all(color: orange.withOpacity(0.3), width: 4)
                                                : Border.all(color: Colors.black26.withOpacity(0.3), width: 4),
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                            image: DecorationImage(
                                              colorFilter: new ColorFilter.mode(purple, BlendMode.dstATop),
                                              image: AssetImage('asset/image/bt_happy.png'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("good",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: (feeling == 'good') ? dark_orange : Colors.black))
                                      ])),
                                  InkWell(
                                      onTap: () {
                                        changeFeeling("very_good");
                                      },
                                      child: Column(children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: (feeling == 'very_good')
                                                ? Border.all(color: orange.withOpacity(0.3), width: 4)
                                                : Border.all(color: Colors.black26.withOpacity(0.3), width: 4),
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                            image: DecorationImage(
                                              colorFilter: new ColorFilter.mode(purple, BlendMode.dstATop),
                                              image: AssetImage('asset/image/bt_excited.png'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("very_good",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: (feeling == 'very_good') ? dark_orange : Colors.black))
                                      ])),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Would you like to describe in more detail?",
                                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                onChanged: (val) {
                                  mood = val;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "What caused this emotion?",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Places",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                // why, one line to describe how you feel? // school, work, friends, home/family, personal
                                // people, place, things, thoughts, activities, situations
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  extraWidget("school", "School", 'school'),
                                  extraWidget("work", "Work", 'work'),
                                  extraWidget("home", "Home", 'home'),
                                  extraWidget("other", "Other", 'other'),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Activities",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                // why, one line to describe how you feel? // school, work, friends, home/family, personal
                                // people, place, things, thoughts, activities, situations
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  extraWidget("shopping", "Shopping", 'shopping'),
                                  extraWidget("insomnia", "Insomnia", 'insomnia'),
                                  extraWidget("walking", "Walking", 'walking'),
                                  extraWidget("reading", "reading", 'reading'),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Would you like to record any additional information?",
                                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                onChanged: (val) {
                                  oneLine = val;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    createMood();
                                  },
                                  child: purpleButton(context, 'Save')),
                            ],
                          ))))));
  }

  void changeFeeling(String feel) {
    feeling = feel;
    setState(() {});
  }

  Column extraWidget(String img, String name, String val) {
    return Column(children: [
      Stack(children: [
        GestureDetector(
            onTap: () {
              if (selectedCauses.contains(val)) {
                selectedCauses.remove(val);
              } else {
                selectedCauses.add(val);
              }
              setState(() {});
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(shape: BoxShape.circle, color: dark_purple),
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: new ColorFilter.mode(Colors.white, BlendMode.dstIn),
                      image: AssetImage('asset/image/$img.png'),
                      fit: BoxFit.fitWidth),
                ),
              ),
            )),
        Positioned(
          top: 0,
          right: 0,
          child: (selectedCauses.contains(val))
              ? Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: Center(
                    child: Icon(Icons.check_circle, color: orange),
                  ),
                )
              : Container(),
        ),
      ]),
      SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      )
    ]);
  }
}

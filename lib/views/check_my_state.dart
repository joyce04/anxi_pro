import 'package:anxi_pro/services/database.dart';
import 'package:anxi_pro/views/dashboard.dart';
import 'package:anxi_pro/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class CheckMyState extends StatefulWidget {
  @override
  _CheckMyStateState createState() => _CheckMyStateState();
}

class _CheckMyStateState extends State<CheckMyState> {
  final _formKey = GlobalKey<FormState>();
  String mood, oneLine;
  DatabaseService dbservice = new DatabaseService();

  bool _isLoading = false;

  createMood() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      String moodId = randomAlphaNumeric(4) +
          '_' +
          DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, String> moodMap = {
        'moodId': moodId,
        'mood': mood,
        'oneLine': oneLine
      };
      await dbservice.addMood(moodMap, moodId).then((val) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        });
      });
    }
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
        body: _isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Form(
                key: _formKey,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // why, one line to describe how you feel? // school, work, friends, home/family, personal
                        // people, place, things, thoughts, activities, situations
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "Please, tell me" : null,
                          decoration:
                              InputDecoration(hintText: "How do you feel?"),
                          onChanged: (val) {
                            mood = val;
                          },
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: "One line diary"),
                          onChanged: (val) {
                            oneLine = val;
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              createMood();
                            },
                            child: purpleButton(context, 'Save')),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ))));
  }
}

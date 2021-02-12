import 'dart:convert';

import 'package:anxi_pro/models/question.dart';
import 'package:anxi_pro/services/database.dart';
import 'package:anxi_pro/widgets/radio_widgets.dart';
import 'package:anxi_pro/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaveSurvey extends StatefulWidget {
  final String surveyId;

  SaveSurvey(this.surveyId);

  @override
  _SaveSurveyState createState() => _SaveSurveyState();
}

int total = 0;
int answered = 0;

class _SaveSurveyState extends State<SaveSurvey> {
  DatabaseService dbService = new DatabaseService();
  List<RadioQuestion> radioQuestions = [];

  Future getQuestionModelFromSnapshot() async {
    bool shuffle = false;

    dbService.getSurveyQuestions(widget.surveyId).then((val) {
      answered = 0;

      val.docs.forEach((doc) {
        RadioQuestion question = new RadioQuestion();
        question.title = doc.data()['title'];

        var optionJson =
            json.decode(doc.data()['answer_option'])['content'] as List;

        List<phqAnswerOption> answerOptions =
            optionJson.map((op) => phqAnswerOption.fromJson(op)).toList();

        if (shuffle) {
          answerOptions.shuffle();
        }
        question.answer_options = answerOptions;
        radioQuestions.add(question);
      });
      total = radioQuestions.length;
      print('$total, ${widget.surveyId}');
    });
    return radioQuestions;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black54),
        brightness: Brightness.dark,
      ),
      body: Container(
          child: Column(
        children: [
          radioQuestions.length == 0
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : Container(
                  child: FutureBuilder(
                  future: getQuestionModelFromSnapshot(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return ListView.builder(
                      padding: EdgeInsets.all(15),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: radioQuestions.length,
                      itemBuilder: (context, index) {
                        return QuestionTile(
                            radioQuestion: radioQuestions[index], index: index);
                      },
                    );
                  },
                ))
        ],
      )),
    );
  }
}

class QuestionTile extends StatefulWidget {
  final RadioQuestion radioQuestion;
  final int index;

  QuestionTile({this.radioQuestion, this.index});

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  List<RadioTile> radioTiles;
  String optionSelected = '';

  whenPressed(int index) {
    setState(() {
      for (var i = 0; i < radioTiles.length; i++) {
        if (i == index) {
          radioTiles[i].selected = true;
          optionSelected = radioTiles[i].val;
        } else {
          radioTiles[i].selected = false;
        }
      }
    });
  }

  List<RadioTile> generateOptions() {
    var radioOptions = List<RadioTile>();
    for (var i = 0; i < widget.radioQuestion.answer_options.length; i++) {
      radioOptions.add(RadioTile(
        option: '✓',
        val: widget.radioQuestion.answer_options[i].val,
        desc: widget.radioQuestion.answer_options[i].desc,
        selected: false,
        onPressed: () => {whenPressed(i)},
      ));
    }
    return radioOptions;
  }

  @override
  void initState() {
    super.initState();
    radioTiles = generateOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.radioQuestion.title,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: radioTiles,
            )
          ],
        ));
  }
}

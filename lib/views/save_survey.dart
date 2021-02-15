import 'dart:convert';

import 'package:anxi_pro/models/question.dart';
import 'package:anxi_pro/services/auth.dart';
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
  Stream questionStream;
  List<QuestionTile> questionTiles = [];
  AuthService authService = new AuthService();

  RadioQuestion getQuestionModelFromSnapshot(DocumentSnapshot doc, bool shuffle) {
    RadioQuestion question = new RadioQuestion();
    question.title = doc.data()['title'];

    var optionJson = jsonDecode(doc.data()['answer_option'])['content'] as List;

    List<phqAnswerOption> answerOptions = optionJson.map((op) => phqAnswerOption.fromJson(op)).toList();

    if (shuffle) {
      answerOptions.shuffle();
    }
    question.answer_options = answerOptions;
    print(question);
    return question;
  }

  @override
  void initState() {
    super.initState();
    initializeQuestions();
  }

  initializeQuestions() async {
    dbService.getSurveyQuestions(widget.surveyId).then((val) {
      setState(() {
        questionStream = val;
      });
      answered = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            child: StreamBuilder(
                stream: questionStream,
                builder: (context, snapshot) {
                  total = snapshot.data.docs.length;
                  return snapshot.data == null
                      ? Container(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.all(15),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            QuestionTile qt = QuestionTile(
                                qId: snapshot.data.docs[index].id,
                                radioQuestion: getQuestionModelFromSnapshot(snapshot.data.docs[index], false),
                                index: index);
                            questionTiles.add(qt);
                            return qt;
                          },
                        );
                })),
        GestureDetector(
            onTap: () {
              int answered = 0;
              List<Answer> saved_answers = [];
              for (var t in questionTiles) {
                if (t.optionSelected.length > 0) {
                  answered += 1;
                  saved_answers.add(Answer(t.qId, t.optionSelected));
                }
              }

              if (answered == questionTiles.length) {
                print('save to firebase');
                dbService
                    .saveSurveyAnwsers(new UserAnswer(authService.getCurrentUserUid(), widget.surveyId, saved_answers));
                Navigator.pop(context);
              }

              print(saved_answers);
            },
            child: purpleButton(context, 'Save'))
      ],
    )));
  }
}

class QuestionTile extends StatefulWidget {
  final String qId;
  final RadioQuestion radioQuestion;
  final int index;
  String optionSelected = '';

  QuestionTile({this.qId, this.radioQuestion, this.index});

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  List<RadioTile> radioTiles;

  _whenPressed(int index) {
    print(index);
    print(radioTiles[index].selected);
    for (var i = 0; i < radioTiles.length; i++) {
      if (i == index) {
        radioTiles[i].selected = true;
        widget.optionSelected = radioTiles[i].val;
      } else {
        radioTiles[i].selected = false;
        radioTiles[i].update();
      }
    }
    print(radioTiles[index].selected);
    print(widget.optionSelected);
  }

  List<RadioTile> generateOptions() {
    return widget.radioQuestion.answer_options.asMap().entries.map((entry) {
      int idx = entry.key;
      phqAnswerOption values = entry.value;
      return RadioTile(
        option: '✓',
        val: values.val,
        desc: values.desc,
        onPressed: () {
          _whenPressed(idx);
        },
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    radioTiles = generateOptions();
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${widget.index + 1}.  ${widget.radioQuestion.title}",
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

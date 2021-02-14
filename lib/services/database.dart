import 'dart:convert';

import 'package:anxi_pro/models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addMood(Map mood, String moodId) async {
    await FirebaseFirestore.instance
        .collection('moods')
        .doc(moodId)
        .set(mood)
        .catchError((e) {
      print(e.toString());
    });
  }

  // Future<void> addMoodDetail(Map moodDetail, String moodId) async {
  //   await FirebaseFirestore.instance
  //       .collection('moods')
  //       .doc(moodId)
  //       .collection('mood_detail')
  //       .add(moodDetail)
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }

  getSurveys() async {
    return await FirebaseFirestore.instance.collection('surveys').snapshots();
  }

  getSurveyQuestions(String surveyId) async {
    return await FirebaseFirestore.instance
        .collection('surveys')
        .doc(surveyId)
        .collection('questions')
        .orderBy('order', descending: false)
        .snapshots();
  }

  Future<void> saveSurveyAnwsers(UserAnswer userAnswer) async {
    // TODO calculate score
    CollectionReference uAnswers =
        FirebaseFirestore.instance.collection('user_answers');
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return uAnswers.add(userAnswer.convertToMap()).then((val) {
      userAnswer.answers.forEach((element) {
        batch.set(uAnswers.doc(val.id).collection('answers').doc(), element.convertToMap());
      });

      return batch.commit();
    }).catchError((e) {
      print(e.toString());
    });
  }
}

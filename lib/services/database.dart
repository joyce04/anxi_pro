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
        .orderBy('order', descending: true)
        .get();
  }
}

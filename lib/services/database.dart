import 'package:anxi_pro/models/mood.dart';
import 'package:anxi_pro/models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addMood(Mood mood) async {
    return FirebaseFirestore.instance.collection('moods').add(mood.convertToMap()).then((val) {
      print('saved to moods');
    }).catchError((e) {
      print(e.toString());
    });
  }

  getMoods(String userId, DateTime selectedDate) async {
    return await FirebaseFirestore.instance
        .collection('moods')
        .where('userId', isEqualTo: userId)
        .where('savedAt', isGreaterThanOrEqualTo: DateTime(selectedDate.year, selectedDate.month, selectedDate.day))
        .where('savedAt', isLessThan: DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1))
        .get();
  }

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
    CollectionReference uAnswers = FirebaseFirestore.instance.collection('user_answers');
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

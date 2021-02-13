import 'package:anxi_pro/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class phqAnswerOption {
  final String desc;
  final int score;
  final String val;

  phqAnswerOption(this.desc, this.score, this.val);

  factory phqAnswerOption.fromJson(dynamic json) {
    return phqAnswerOption(json['desc'], json['score'] as int, json['val']);
  }

  @override
  String toString() {
    return '{${this.desc}, ${this.score}, ${this.val}}';
  }
}

class RadioQuestion {
  String title;
  List<phqAnswerOption> answer_options;
  String selected;
}

class Answer {
  final String questionId;
  final String answer;

  Answer(@required this.questionId, @required this.answer);

  Map<String, String> convertToMap() {
    return {'questionId': this.questionId, 'answer': this.answer};
  }
}

class UserAnswer {
  final String userId;
  final String surveyId;
  Timestamp savedAt;

  final List<Answer> answers;

  UserAnswer(this.userId, this.surveyId, this.answers);

  Map<String, dynamic> convertToMap() {

    return {
      'userId': this.userId,
      'surveyId': this.surveyId,
      'savedAt': Timestamp.now()

    };
  }
}

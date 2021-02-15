import 'package:anxi_pro/color_scheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Map<String, Color> iconColors = {
  'very_bad': very_bad_pink,
  'bad': bad_orange,
  'neutral': neutral_baige,
  'good': okay_green,
  'very_good': good_green
};

Map<String, String> iconImgs = {
  'very_bad': 'bt_verybad.png',
  'bad': 'bt_bad.png',
  'neutral': 'bt_neutral.png',
  'good': 'bt_happy.png',
  'very_good': 'bt_excited.png'
};

class Mood {
  String moodId;
  final String userId;
  final String feeling;
  String feelingDetail;
  String oneLine;
  Timestamp savedAt;
  List<String> causes;

  Mood(this.userId, this.feeling);

  Map<String, dynamic> convertToMap() {
    var moodMap = {'userId': this.userId, 'feeling': this.feeling, 'savedAt': Timestamp.now()};
    if (this.feelingDetail.length > 0) {
      moodMap['feeling_detail'] = this.feelingDetail;
    }
    if (this.oneLine.length > 0) {
      moodMap['one_line'] = this.oneLine;
    }
    if ((this.causes != null) & (this.causes.length > 0)) {
      moodMap['causes'] = this.causes.join(",");
    }

    return moodMap;
  }

  String getHourMin() {
    return new DateFormat.jm()
        .format(DateTime.fromMicrosecondsSinceEpoch(this.savedAt.microsecondsSinceEpoch))
        .toString();
  }

  Color getIconColor() {
    return iconColors[this.feeling];
  }
}

Mood convertFromDocumentSnapShot(QueryDocumentSnapshot snapshot) {
  Mood mood = new Mood(snapshot.data()['userId'], snapshot.data()['feeling']);
  print(snapshot.data()['savedAt']);
  mood.savedAt = snapshot.data()['savedAt'];
  for (var key in ['feeling_detail', 'one_line', 'causes']) {
    if (snapshot.data().containsKey(key)) {
      if (key == 'feeling_detail') {
        mood.feelingDetail = snapshot.data()[key];
      } else if (key == 'one_line') {
        mood.oneLine = snapshot.data()[key];
      } else if (key == 'causes') {
        mood.causes = snapshot.data()[key].split(",");
      }
    }
  }
  return mood;
}

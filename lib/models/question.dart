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

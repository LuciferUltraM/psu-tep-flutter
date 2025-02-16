import 'package:psutep/models/score.dart';

class Examinee {
  int id = 0;
  List<Score> scores = [];
  String? code;
  String? firstname;
  String? lastname;
  String? answer0;
  String? answer1;
  String? answer2;
  String? answer3;
  bool? finish;

  Examinee(
    this.id,
    this.scores, {
    this.code,
    this.firstname,
    this.lastname,
    this.answer0,
    this.answer1,
    this.answer2,
    this.answer3,
    this.finish,
  });

  Examinee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    answer0 = json['answer0'] ?? '';
    answer1 = json['answer1'] ?? '';
    answer2 = json['answer2'] ?? '';
    answer3 = json['answer3'] ?? '';
    finish = json['finish'] ?? false;
    if (json["scores"] != null) {
      scores =
          (json["scores"] as List).map((data) => Score.fromJson(data)).toList();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'firstname': firstname,
        'lastname': lastname,
        'answer0': answer0,
        'answer1': answer1,
        'answer2': answer2,
        'answer3': answer3,
        'finish': finish,
      };
}

// To parse this JSON data, do
//
//     final questions = questionsFromJson(jsonString);

import 'dart:convert';

List<Questions> questionsFromJson(String str) =>
    List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String questionsToJson(List<Questions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
  String category;
  String id;
  String correctAnswer;
  List<String> incorrectAnswers;
  Question question;
  List<String> tags;
  Type type;
  Difficulty difficulty;
  List<dynamic> regions;
  bool isNiche;

  Questions({
    required this.category,
    required this.id,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.question,
    required this.tags,
    required this.type,
    required this.difficulty,
    required this.regions,
    required this.isNiche,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        category: json["category"],
        id: json["id"],
        correctAnswer: json["correctAnswer"],
        incorrectAnswers:
            List<String>.from(json["incorrectAnswers"].map((x) => x)),
        question: Question.fromJson(json["question"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
        type: typeValues.map[json["type"]]!,
        difficulty: difficultyValues.map[json["difficulty"]]!,
        regions: List<dynamic>.from(json["regions"].map((x) => x)),
        isNiche: json["isNiche"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "id": id,
        "correctAnswer": correctAnswer,
        "incorrectAnswers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
        "question": question.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "type": typeValues.reverse[type],
        "difficulty": difficultyValues.reverse[difficulty],
        "regions": List<dynamic>.from(regions.map((x) => x)),
        "isNiche": isNiche,
      };
}

enum Difficulty { EASY, HARD, MEDIUM }

final difficultyValues = EnumValues({
  "easy": Difficulty.EASY,
  "hard": Difficulty.HARD,
  "medium": Difficulty.MEDIUM
});

class Question {
  String text;

  Question({
    required this.text,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

enum Type { TEXT_CHOICE }

final typeValues = EnumValues({"text_choice": Type.TEXT_CHOICE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

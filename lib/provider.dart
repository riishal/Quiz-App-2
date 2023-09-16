import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

// ignore_for_file: constant_identifier_names

enum ProviderStatus { LOADING, COMPLETED }

class QuestionsProvider with ChangeNotifier {
  bool match = false;
  int mark = 0;
  List<Questions> data = [];
  ProviderStatus status = ProviderStatus.LOADING;
  void markIncreaser() {
    if (match) {
      mark++;
    }
    match = false;
    notifyListeners();
  }

  Future<void> answerCheck(
      int buttonindex, pageindex, index, int correctIndex) async {
    buttonindex = index;
    buttonindex == correctIndex ? match = true : match = false;
    // ignore: avoid_print
    print(match);
    notifyListeners();
  }

  fetchQuestions() async {
    final response =
        await http.get(Uri.parse('https://the-trivia-api.com/v2/questions'));

    if (response.statusCode == 200) {
      data = questionsFromJson(response.body);
      status = ProviderStatus.COMPLETED;
    } else {
      throw Exception('Failed to load album');
    }
  }

  fetchResult(indexfornextquestion) {
    List<String> results = [];
    results.addAll(data[indexfornextquestion].incorrectAnswers);
    results.add(data[indexfornextquestion].correctAnswer);
    // results.shuffle();
    print(results);
  }
}

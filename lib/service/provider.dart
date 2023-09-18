import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/model.dart';

// ignore_for_file: constant_identifier_names

enum ProviderStatus { LOADING, COMPLETED }

class QuestionsProvider with ChangeNotifier {
  bool match = false;
  int mark = 0;
  List<Questions> data = [];
  List<String> results = [];
  ProviderStatus status = ProviderStatus.LOADING;
  void markIncreaser() {
    if (match) {
      mark++;
    }
    match = false;
    notifyListeners();
  }

  Future<void> answerCheck(int buttonindex, pageindex, index, String result,
      int indexfornextquestion) async {
    buttonindex = index;
    if (result == data[indexfornextquestion].correctAnswer) {
      mark++;
    }
    // markIncreaser();
    // ignore: avoid_print
    print(mark);
    // notifyListeners();
  }

  fetchQuestions() async {
    final response =
        await http.get(Uri.parse('https://the-trivia-api.com/v2/questions'));
    if (response.statusCode == 200) {
      data = questionsFromJson(response.body);
      status = ProviderStatus.COMPLETED;
      notifyListeners();
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<String> fetchResult(indexfornextquestion) {
    if (indexfornextquestion < 10) {
      results.addAll(data[indexfornextquestion].incorrectAnswers);
      results.add(data[indexfornextquestion].correctAnswer);
      results.shuffle();
      print(results);
    }
    return results;
  }
}

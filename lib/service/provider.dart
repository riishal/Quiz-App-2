import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/model.dart';

import '../models/review_model.dart';

// ignore_for_file: constant_identifier_names

enum ProviderStatus { LOADING, COMPLETED }

class QuestionsProvider with ChangeNotifier {
  bool match = false;
  int mark = 0;
  List<Questions> data = [];
  List<String> results = [];
  int buttonIndex = -1;
  bool isLoading = false;
  int indexfornextquestion = 0;
  List<ReviewModel> reviewList = [];
  String selectedChoice = '';

  ProviderStatus status = ProviderStatus.LOADING;
  void markIncreaser() {
    print('///////////////called');
    if (match) {
      mark++;
    }
    match = false;
    notifyListeners();
  }

  Future<void> answerCheck(int index, String result) async {
    buttonIndex = index;
    selectedChoice = result;
    if (result == data[indexfornextquestion].correctAnswer) {
      match = true;
    }
    // ignore: avoid_print
    print(match);
    notifyListeners();
  }

  addToReviewList() {
    if (indexfornextquestion < 10) {
      ReviewModel reviewModel = ReviewModel(
          question: data[indexfornextquestion].question.text,
          choice: selectedChoice,
          correctAnswer: data[indexfornextquestion].correctAnswer);
      reviewList.add(reviewModel);
    }
    for (var r in reviewList) {
      print([r.question, r.choice, r.correctAnswer].toString());
    }
  }

  fetchQuestions() async {
    isLoading = true;
    final response =
        await http.get(Uri.parse('https://the-trivia-api.com/v2/questions'));
    if (response.statusCode == 200) {
      data = questionsFromJson(response.body);
      status = ProviderStatus.COMPLETED;
      fetchResult(indexfornextquestion);
      isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load album');
    }
  }

  fetchResult(indexfornextquestion) {
    results = [];
    if (indexfornextquestion < 10) {
      results.addAll(data[indexfornextquestion].incorrectAnswers);
      results.add(data[indexfornextquestion].correctAnswer);
      results.shuffle();
      print(results);
    }
  }
}

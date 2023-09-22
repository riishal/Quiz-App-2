import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/model.dart';
import 'package:quiz_app/view/quiz_page.dart';

import '../models/review_model.dart';
import '../view/result_page.dart';

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
  int pageIndex = 1;

  ProviderStatus status = ProviderStatus.LOADING;
  void markIncreaser() {
    print('///////////////called');
    if (match) {
      mark++;
    }
    match = false;
    notifyListeners();
  }

  backToPreviousPage(context, firebaseUser, userModel) {
    if (indexfornextquestion > 0) {
      indexfornextquestion--;
    } else if (indexfornextquestion < 0) {
      indexfornextquestion = 0;
    }
    if (pageIndex > 1) {
      pageIndex--;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  QuizPage(userModel: userModel, firebaseUser: firebaseUser)),
          (route) => false);
    }
    print('////////////////// pageIndex: $pageIndex');
    print('////////////////// index for next: $indexfornextquestion');

    fetchResult(indexfornextquestion);
    notifyListeners();
  }

  nextPage(context, firebaseUser, userModel) {
    markIncreaser();
    addToReviewList();
    indexfornextquestion++;
    fetchResult(indexfornextquestion);
    pageIndex < 10
        ? pageIndex++
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                firebaseUser: firebaseUser,
                userModel: userModel,
              ),
            ),
            (route) => false);
    buttonIndex = -1;
    selectedChoice = '';
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
    if (indexfornextquestion < 10 && indexfornextquestion > 0) {
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

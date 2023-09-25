import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/view/quiz_page.dart';

import '../view/result_page.dart';

// ignore_for_file: constant_identifier_names

enum ProviderStatus { LOADING, COMPLETED }

class QuestionsProvider with ChangeNotifier {
  List<QuizModel> quizList = [];
  List<List<String>> choices = [];

  bool match = false;
  int mark = 0;
  List<Questions> data = [];
  List<String> results = [];
  int buttonIndex = -1;
  bool isLoading = false;
  int indexfornextquestion = 0;
  // List<ReviewModel> reviewList = [];
  String selectedChoice = '';
  int pageIndex = 1;
  bool previousPage = false;

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
    previousPage = true;
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

    // fetchResult(indexfornextquestion);
    // results = reviewList[indexfornextquestion].choiceList;
    // buttonIndex = reviewList[indexfornextquestion].selectedIndex;
    // print(
    //     '////////////////////////////back choices ${reviewList[indexfornextquestion].choiceList}');
    notifyListeners();
  }

  nextPage(context, firebaseUser, userModel) {
    markIncreaser();
    indexfornextquestion++;
    notifyListeners();
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
    previousPage = false;
  }

  Future<void> answerCheck(int index, String result) async {
    buttonIndex = index;
    selectedChoice = result;
    if (result == quizList[indexfornextquestion].answer) {
      match = true;
    }
    quizList[indexfornextquestion].selectedIndex = index;
    print(match);
    notifyListeners();
  }

  // addToReviewList() {
  //   if (indexfornextquestion < 10 && indexfornextquestion >= 0) {
  //     ReviewModel reviewModel = ReviewModel(
  //         question: data[indexfornextquestion].question.text,
  //         choice: selectedChoice,
  //         correctAnswer: data[indexfornextquestion].correctAnswer,
  //         choiceList: results,
  //         selectedIndex: buttonIndex);
  //     reviewList.add(reviewModel);
  //   }
  // print('//////////////////////////// previous page: $previousPage');
  // for (var r in reviewList) {
  //   print('//////////////////////////// choiceList : ${r.choiceList}');
  // }
  // }

  fetchQuestions() async {
    isLoading = true;
    final response =
        await http.get(Uri.parse('https://the-trivia-api.com/v2/questions'));
    if (response.statusCode == 200) {
      data = questionsFromJson(response.body);
      status = ProviderStatus.COMPLETED;
      // fetchResult(indexfornextquestion);
      for (var i = 0; i < data.length; i++) {
        QuizModel quizModel = QuizModel(
            id: i,
            question: data[i].question.text,
            answer: data[i].correctAnswer,
            choices: arrangeChoices(i),
            selectedIndex: -1);
        quizList.add(quizModel);
      }
      print('///////////////////// quizList: ${quizList.length}}');
      isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<String> arrangeChoices(int i) {
    List<String> shuffleChoice = [];
    shuffleChoice.addAll(data[i].incorrectAnswers);
    shuffleChoice.add(data[i].correctAnswer);
    shuffleChoice.shuffle();
    // choices.add(shuffleChoice);
    print('////////////////// shuffle: $choices');
    return shuffleChoice;
  }
}

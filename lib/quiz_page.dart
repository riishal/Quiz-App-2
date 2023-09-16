import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider.dart';
import 'package:quiz_app/result_page.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    int mark = 0;
    int pageIndex = 1;
    int buttonIndex = -1;
    int indexfornextquestion = 0;
    bool match = false;
    List<String> choice = ['A.', 'B.', 'C.', 'D.'];
    return Builder(builder: (context) {
      var getdata = Provider.of<QuestionsProvider>(context, listen: false);
      getdata.fetchQuestions();
      if (getdata.status == ProviderStatus.COMPLETED) {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 138, 197, 246),
          body: SafeArea(
              child: Container(
            child: Column(children: [
              SizedBox(
                height: 40,
              ),
              CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 40,
                  child: Text(
                    "$pageIndex/10",
                    style: GoogleFonts.asap(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 200,
                  width: 360,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 290,
                          child: Text(
                            getdata.data[0].question.text,
                            // getdata.data[0].questions[indexfornextquestion]
                            //     .question,
                            style: GoogleFonts.asap(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 340,
                width: 360,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      getdata.fetchResult(indexfornextquestion);

                      return GestureDetector(
                        onTap: () {
                          buttonIndex = index;
                          // getdata.answerCheck(
                          //     buttonIndex,
                          //     pageIndex,
                          //     index,
                          //     getdata
                          //         .data[0]
                          //         .questions[indexfornextquestion]
                          //         .correctIndex);
                        },
                        child: Container(
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                choice[index],
                                style: GoogleFonts.asap(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: buttonIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 27,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  getdata.data[indexfornextquestion]
                                      .incorrectAnswers[index],
                                  // results[index],
                                  // getdata
                                  //     .data[0]
                                  //     .questions[indexfornextquestion]
                                  //     .answers[index],
                                  style: GoogleFonts.asap(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w400,
                                      color: buttonIndex == index
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ],
                          )),
                          height: 70,
                          width: 200,
                          decoration: BoxDecoration(
                              color: buttonIndex == index
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemCount: 3),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 170,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      getdata.markIncreaser();
                      indexfornextquestion++;
                      pageIndex < 10
                          ? pageIndex++
                          : Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultPage(),
                              ),
                              (route) => false);
                      buttonIndex = -1;

                      print(context.read<QuestionsProvider>().mark);
                    },
                    child: Text(
                      "NEXT",
                      style: GoogleFonts.asap(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              )
            ]),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB(255, 138, 197, 246),
                  Colors.blue,
                  Color.fromARGB(255, 138, 197, 246)
                ])),
          )),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}

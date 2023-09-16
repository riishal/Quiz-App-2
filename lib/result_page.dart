import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider.dart';
import 'package:quiz_app/quiz_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool win = context.read<QuestionsProvider>().mark >= 5;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.white,
              Colors.white,
              Color.fromARGB(255, 138, 197, 246),
              // Color.fromARGB(255, 138, 197, 246),
              // Colors.blue,
              // Color.fromARGB(255, 138, 197, 246)
            ])),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 23,
                ),
                Text(
                  "Result",
                  style: GoogleFonts.asap(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 100,
                ),
                win
                    ? Text(
                        "GREAT",
                        style: GoogleFonts.asap(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    : Text(
                        "Oh no!",
                        style: GoogleFonts.asap(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                SizedBox(
                  height: 20,
                ),
                CircularPercentIndicator(
                  animation: true,
                  radius: 130,
                  lineWidth: 30,
                  circularStrokeCap: CircularStrokeCap.round,
                  // restartAnimation: true,
                  percent: context.read<QuestionsProvider>().mark / 10,
                  center: Text(
                    "${context.read<QuestionsProvider>().mark}/10",
                    style: GoogleFonts.asap(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: win ? Colors.green : Colors.red),
                  ),
                  progressColor: win ? Colors.green : Colors.red,
                ),
                SizedBox(
                  height: 16,
                ),
                win
                    ? Column(
                        children: [
                          Text(
                            "Congratulations",
                            style: GoogleFonts.asap(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(
                            "You won!",
                            style: GoogleFonts.asap(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      )
                    : Text(
                        "You Lost!",
                        style: GoogleFonts.asap(
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                            color: Colors.red),
                      ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: 170,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        context.read<QuestionsProvider>().mark = 0;

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizPage(),
                            ),
                            (route) => false);
                      },
                      child: Text(
                        "TRY AGAIN",
                        style: GoogleFonts.asap(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                )
              ],
            ),
            win
                ? LottieBuilder.network(
                    'https://assets5.lottiefiles.com/packages/lf20_wys2rrr6.json')
                : SizedBox()
          ],
        ),
      )),
    );
  }
}

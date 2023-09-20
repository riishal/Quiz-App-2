import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/service/provider.dart';
import 'package:quiz_app/view/quiz_page.dart';
import 'package:quiz_app/view/resultView_page.dart';

import '../models/user_model.dart';

class ResultPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const ResultPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    bool win = context.read<QuestionsProvider>().mark >= 5;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 23,
                ),
                Text(
                  "Result",
                  style: GoogleFonts.asap(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                // SizedBox(
                //   height: 100,
                // ),

                const SizedBox(
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
                    : Column(
                        children: [
                          Text(
                            "Oh no!",
                            style: GoogleFonts.asap(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "You Lost",
                            style: GoogleFonts.asap(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 170,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.padding_outlined,
                          color: Colors.black,
                        ),
                        label: Text(
                          "View Result",
                          style: GoogleFonts.asap(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultViewPage(),
                              ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 170,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            context.read<QuestionsProvider>().mark = 0;
                            var getdata = Provider.of<QuestionsProvider>(
                                context,
                                listen: false);
                            getdata.indexfornextquestion = 0;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                      firebaseUser: firebaseUser,
                                      userModel: userModel),
                                ),
                                (route) => false);
                          },
                          child: Text(
                            "TRY AGAIN",
                            style: GoogleFonts.asap(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
            win
                ? LottieBuilder.network(
                    'https://assets5.lottiefiles.com/packages/lf20_wys2rrr6.json')
                : const SizedBox(),
          ],
        ),
      )),
    );
  }
}

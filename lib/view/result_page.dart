import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:quiz_app/view/profile_view.dart';
import 'package:quiz_app/view/quiz_page.dart';
import 'package:quiz_app/view/resultView_page.dart';

import '../models/user_model.dart';
import '../provider/provider.dart';
import '../service/ui_helper.dart';

class ResultPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const ResultPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(children: [
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfilePic(
                                          userModel: userModel,
                                          firebaseUser: firebaseUser,
                                        )));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            backgroundImage:
                                NetworkImage(userModel.profilepic!),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userModel.fullName!,
                          style: GoogleFonts.asap(
                              fontSize: 20,
                              shadows: [
                                const Shadow(
                                    color: Colors.black,
                                    blurRadius: 11,
                                    offset: Offset(2, 1)),
                              ],
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ]),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          UIHelper.showLogOut(context);
                        },
                        child: const Icon(
                          Icons.logout_outlined,
                          color: Colors.red,
                        )),
                  ],
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
                                color: Colors.red),
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
                      height: size.height * 0.07,
                      width: size.width * 0.43,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.padding_outlined,
                          color: Colors.black,
                        ),
                        label: Text(
                          "View Result",
                          style: GoogleFonts.asap(
                              fontSize: 18,
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
                                builder: (context) => const ResultViewPage(),
                              ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.07,
                      width: size.width * 0.43,
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
                            getdata.quizList = [];
                            getdata.indexfornextquestion = 0;
                            getdata.pageIndex = 1;
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

  delectData() async {
    await FirebaseFirestore.instance.collection("Quiz").doc().delete();
  }
}

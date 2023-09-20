import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/service/ui_helper.dart';
import 'package:quiz_app/service/provider.dart';

import '../models/user_model.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const QuizPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late QuestionsProvider getdata;
  int pageIndex = 1;
  bool match = false;
  List<String> choice = ['A.', 'B.', 'C.', 'D.'];

  @override
  void initState() {
    getdata = Provider.of<QuestionsProvider>(context, listen: false);
    getdata.fetchQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(builder: (context, getdata, child) {
      if (getdata.status == ProviderStatus.COMPLETED) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 138, 197, 246),
          body: getdata.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color.fromARGB(255, 138, 197, 246),
                        Colors.blue,
                        Color.fromARGB(255, 138, 197, 246)
                      ])),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: ListView(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[400],
                                    backgroundImage: NetworkImage(
                                        widget.userModel.profilepic!),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.userModel.fullName!,
                                    style: GoogleFonts.asap(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
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
                              ))
                        ],
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
                      const SizedBox(
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
                                const SizedBox(
                                  width: 10,
                                ),
                                const CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.amber,
                                  child: Icon(
                                    Icons.question_mark,
                                    color: Color.fromARGB(255, 48, 47, 47),
                                    size: 17,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    (getdata.indexfornextquestion < 10)
                                        ? getdata
                                            .data[getdata.indexfornextquestion]
                                            .question
                                            .text
                                        : '',
                                    style: GoogleFonts.asap(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          // height: 340,
                          width: 360,
                          child: Column(
                            children: [
                              ...List.generate(getdata.results.length, (index) {
                                var result = getdata.results[index];

                                return GestureDetector(
                                  onTap: () {
                                    getdata.answerCheck(index, result);
                                  },
                                  child: Container(
                                    height: 70,
                                    // width: 200,
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        color: getdata.buttonIndex == index
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '${index + 1}.',
                                          style: GoogleFonts.asap(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                            color: getdata.buttonIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 27,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            result,
                                            style: GoogleFonts.asap(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    getdata.buttonIndex == index
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                );
                              })
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 5, right: 5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              getdata.markIncreaser();
                              getdata.indexfornextquestion++;
                              getdata.fetchResult(getdata.indexfornextquestion);
                              pageIndex <= 9
                                  ? pageIndex++
                                  : Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultPage(
                                          firebaseUser: widget.firebaseUser,
                                          userModel: widget.userModel,
                                        ),
                                      ),
                                      (route) => false);
                              getdata.buttonIndex = -1;

                              // print(context.read<QuestionsProvider>().mark);
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
                  ),
                )),
        );
      } else {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }
    });
  }
}

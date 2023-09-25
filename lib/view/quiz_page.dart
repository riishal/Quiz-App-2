import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/provider.dart';
import 'package:quiz_app/service/ui_helper.dart';

import 'package:quiz_app/view/profile_view.dart';

import '../models/user_model.dart';

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
  List<String> choice = ['A.', 'B.', 'C.', 'D.'];

  @override
  void initState() {
    getdata = Provider.of<QuestionsProvider>(context, listen: false);
    getdata.fetchQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<QuestionsProvider>(builder: (context, getdata, child) {
      if (getdata.status == ProviderStatus.COMPLETED) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 138, 197, 246),
          body: getdata.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
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
                        Colors.white,
                        Color.fromARGB(255, 138, 197, 246)
                      ])),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: ListView(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfilePic(
                                                    userModel: widget.userModel,
                                                    firebaseUser:
                                                        widget.firebaseUser,
                                                  )));
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      backgroundImage: NetworkImage(
                                          widget.userModel.profilepic!),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.userModel.fullName!,
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
                              ))
                        ],
                      ),
                      CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 30,
                          child: Text(
                            "${getdata.pageIndex}/10",
                            style: GoogleFonts.asap(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: size.height * 0.20,
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
                                  (getdata.indexfornextquestion < 10 &&
                                          getdata.indexfornextquestion >= 0)
                                      ? getdata
                                          .quizList[
                                              getdata.indexfornextquestion]
                                          .question
                                      : '',
                                  style: GoogleFonts.asap(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          // height: 340,
                          width: 360,
                          child: (getdata.indexfornextquestion < 10 &&
                                  getdata.indexfornextquestion >= 0)
                              ? Column(
                                  children: [
                                    ...List.generate(
                                        getdata
                                            .quizList[
                                                getdata.indexfornextquestion]
                                            .choices
                                            .length, (index) {
                                      var result = getdata
                                          .quizList[
                                              getdata.indexfornextquestion]
                                          .choices[index];

                                      return GestureDetector(
                                        onTap: () {
                                          getdata.answerCheck(index, result);
                                        },
                                        child: Container(
                                          height: 60,
                                          // width: 200,
                                          margin: const EdgeInsets.only(
                                              bottom: 10, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                              color: getdata
                                                          .quizList[getdata
                                                              .indexfornextquestion]
                                                          .selectedIndex ==
                                                      index
                                                  ? Colors.black
                                                  : Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                    blurRadius: 1,
                                                    color: Colors.grey,
                                                    offset: Offset(3, 3)),
                                              ],
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
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: getdata
                                                              .quizList[getdata
                                                                  .indexfornextquestion]
                                                              .selectedIndex ==
                                                          index
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  width: 260,
                                                  child: Text(
                                                    result,
                                                    style: GoogleFonts.asap(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: getdata
                                                                    .quizList[
                                                                        getdata
                                                                            .indexfornextquestion]
                                                                    .selectedIndex ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      );
                                    })
                                  ],
                                )
                              : Container()),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.07,
                            width: size.width * 0.40,
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 5, right: 5),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  getdata.backToPreviousPage(context,
                                      widget.firebaseUser, widget.userModel);
                                },
                                child: Text(
                                  "PREVIOUS",
                                  style: GoogleFonts.asap(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )),
                          ),
                          Container(
                            height: size.height * 0.07,
                            width: size.width * 0.40,
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 5, right: 5),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  // uploadData(getdata.results[getdata.buttonIndex]);

                                  getdata.nextPage(context, widget.firebaseUser,
                                      widget.userModel);

                                  // print(context.read<QuestionsProvider>().mark);
                                },
                                child: Text(
                                  "NEXT",
                                  style: GoogleFonts.asap(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                          ),
                        ],
                      )
                    ]),
                  ),
                )),
        );
      } else {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        );
      }
    });
  }
}

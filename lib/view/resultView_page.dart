import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/service/provider.dart';

class ResultViewPage extends StatefulWidget {
  const ResultViewPage({super.key});

  @override
  State<ResultViewPage> createState() => _ResultViewPageState();
}

class _ResultViewPageState extends State<ResultViewPage> {
  late QuestionsProvider getdata;
  List<String> numers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

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
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Text(
              "Quiz Review",
              style: GoogleFonts.asap(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          body: getdata.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: size.height * 0.88,
                          width: size.width * 0.99,
                          decoration: BoxDecoration(color: Colors.white),
                          child: ListView.separated(
                              itemBuilder: (context, index) => Container(
                                    height: 130,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${numers[index]} -',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 320,
                                              height: 50,
                                              child: Text(
                                                getdata
                                                    .data[index].question.text,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 170,
                                              child: Text(
                                                "You Chose :dddddd ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 170,
                                              child: Text(
                                                "Correct Answer : ${getdata.data[index].correctAnswer}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              separatorBuilder: (context, index) => SizedBox(
                                    child: Divider(),
                                    height: 10,
                                  ),
                              itemCount: 10),
                        )
                      ]),
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

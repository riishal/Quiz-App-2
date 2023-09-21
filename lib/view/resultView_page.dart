import 'package:flutter/material.dart';
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
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            width: size.width * 0.99,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final review = getdata.reviewList[index];
                                  return Container(
                                    // height: 130,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FittedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${numers[index]} - ',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.fade),
                                              ),
                                              SizedBox(
                                                width: 320,
                                                height: 50,
                                                child: Text(
                                                  review.question,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                "You Chose : ${review.choice}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Correct Answer : ${review.correctAnswer}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 10,
                                      child: Divider(),
                                    ),
                                itemCount: getdata.reviewList.length),
                          ),
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

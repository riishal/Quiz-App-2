import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/provider.dart';

class ResultViewPage extends StatefulWidget {
  const ResultViewPage({super.key});

  @override
  State<ResultViewPage> createState() => _ResultViewPageState();
}

class _ResultViewPageState extends State<ResultViewPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<QuestionsProvider>(builder: (context, getdata, child) {
      if (getdata.status == ProviderStatus.COMPLETED) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 138, 197, 246),
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
                                  final review = getdata.quizList[index];
                                  return Container(
                                    // height: 130,
                                    decoration: BoxDecoration(
                                        boxShadow: const [BoxShadow()],
                                        borderRadius: BorderRadius.circular(10),
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
                                                '${review.id + 1} - ',
                                                style: const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            review.selectedIndex != -1
                                                ? review.choices[review
                                                            .selectedIndex] ==
                                                        review.answer
                                                    ? const Icon(
                                                        Icons.done_rounded,
                                                        size: 28,
                                                        color: Colors.green,
                                                      )
                                                    : const Icon(
                                                        Icons.cancel_outlined,
                                                        size: 28,
                                                        color: Colors.red,
                                                      )
                                                : const Icon(
                                                    Icons.cancel_outlined,
                                                    size: 28,
                                                    color: Colors.red,
                                                  ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              "You Chose : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                            Expanded(
                                              child: Text(
                                                review.selectedIndex != -1
                                                    ? review.choices[
                                                        review.selectedIndex]
                                                    : "",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 50,
                                            ),
                                            const Text(
                                              "Correct Answer : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                            Expanded(
                                              child: Text(
                                                review.answer,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 15,
                                    ),
                                itemCount: getdata.quizList.length),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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

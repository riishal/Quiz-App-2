import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider.dart';
import 'package:quiz_app/quiz_page.dart';

import 'Start_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestionsProvider>(
      create: (context) => QuestionsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartPage(),
      ),
    );
  }
}

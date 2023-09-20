import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/service/firebase_service.dart';
import 'package:quiz_app/service/provider.dart';
import 'package:quiz_app/view/login_page.dart';
import 'package:quiz_app/view/quiz_page.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    //logged In
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelId(currentUser.uid);
    if (thisUserModel != null) {
      runApp(MyAppLoggedIn(
        firebaseUser: currentUser,
        userModel: thisUserModel,
      ));
    } else {
      runApp(MyApp());
    }
  } else {
    //not logged In
    runApp(MyApp());
  }
}

//not logged In
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestionsProvider>(
      create: (context) => QuestionsProvider(),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

//Already loggedIn
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLoggedIn(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestionsProvider>(
      create: (context) => QuestionsProvider(),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: QuizPage(userModel: userModel, firebaseUser: firebaseUser),
      ),
    );
  }
}

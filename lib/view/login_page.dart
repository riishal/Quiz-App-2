import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/view/quiz_page.dart';
import 'package:quiz_app/service/firebase_service.dart';
import 'package:quiz_app/service/ui_helper.dart';
import 'package:quiz_app/view/signUp_page.dart';

import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      UIHelper.showAlertDialog(
          context, "Incomplited Data", "Please fill all the fields");
      print('please fill All fields!');
    } else {
      //login
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? userCredential;
    UIHelper.showLoadingDialog(context, "Logging In..");
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      //Close the Loading Dialog

      Navigator.pop(context);
      //Show Alert Dialog
      UIHelper.showAlertDialog(
          context, "An error occured", ex.message.toString());
      print(ex.message.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      //go to Homepage
      print('Login successful');
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
                userModel: userModel, firebaseUser: userCredential!.user!),
          ));
    }
  }

  void signUpGoogle() async {
    UserCredential? userCredential;
    UIHelper.showLoadingDialog(context, "GoogleSign in...");

    try {
      userCredential = await FirebaseHelper().signInWithGoogle();
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error occured", ex.message.toString());
      print(ex.code.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          email: userCredential.user!.email,
          fullName: userCredential.user!.displayName,
          profilepic: userCredential.user!.photoURL);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then(
        (value) {
          print('New user Created');
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizPage(
                      userModel: newUser, firebaseUser: userCredential!.user!)
                  // CompliteProfile(
                  //     userModel: newUser, firebaseUser: userCredential!.user!),
                  ));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 138, 197, 246),
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 138, 197, 246),
              Colors.blue,
              Color.fromARGB(255, 138, 197, 246)
            ])),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Quiz App",
                style: GoogleFonts.asap(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 48,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: size.height * 0.074,
                width: size.width * 0.89,
                child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    )),
              ),
              const SizedBox(
                height: 19,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: size.height * 0.074,
                width: size.width * 0.89,
                child: TextFormField(
                    obscureText: isHidden,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: togglePasswordView,
                          child: Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          )),
                      hintText: "Password",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      checkValues();
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.asap(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'OR',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: (() {
                      signUpGoogle();
                    }),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: Row(children: <Widget>[
                      Image.asset(
                        'assets/image/google.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Expanded(
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ])),
              ),
            ],
          )),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ));
            },
          )
        ]),
      ),
    );
  }

  togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}

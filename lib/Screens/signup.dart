import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/Login.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  signUp(String email, String password) async {
    if (email == "" && password == "") {
      UiHelper.customAlertbox(context, "Empty");
    }
    UserCredential? usercredential;
    try {
      usercredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login())
        );
        return null;
      });
    } on FirebaseAuthException catch (ex) {
      return UiHelper.customAlertbox(context, ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.customTextField(emailController, "Email", false,true),
          UiHelper.customTextField(passwordController, "Password", true,false),
          UiHelper.customButtom(() {
            signUp(emailController.text.toString(),passwordController.text.toString());
          }, "Signup")
        ],
      ),
    );
  }
}

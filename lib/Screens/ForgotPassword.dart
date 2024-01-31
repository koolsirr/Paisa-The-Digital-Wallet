import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';

import 'LoginScreen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController=TextEditingController();
  forgotpassword(String email)async{
    if(email==""){
      return UiHelper.customAlertbox(context, "Enter an Email to Reset Password");
    }
    else{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          UiHelper.customTextField(emailController, "Please enter your Email", false),
          const SizedBox(height: 20),
          UiHelper.customButtom(() {
            forgotpassword(emailController.text.toString());
          }, "Reset Password")
        ],),
      ),
    );
  }
}

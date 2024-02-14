import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'LoginScreen.dart';
import 'UiHelper.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String email = FirebaseAuth.instance.currentUser?.email ?? '';
  TextEditingController pinController = TextEditingController();
  final pinLength = 6;

  transaction(String pin) async {
    if (pin == "" || pin.length != pinLength) {
      return UiHelper.customAlertbox(context, "Please Enter a 6-digit pin");
    }
    try {
      await FirebaseFirestore.instance.collection("Users").doc(email).update({
        "Transaction Pin": pin
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen(
              )));
    } catch (e) {
      print('Error updating transaction pin: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(
                height: 25,
              ),
              const Text(
                "Transaction Pin",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your Transaction Pin to get started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              UiHelper.customTextField(
                  pinController, "Transaction Pin", false, true),
              const SizedBox(
                height: 20,
              ),
              UiHelper.customButtom(() async {
                pinLength;
                transaction(pinController.text.toString());

              }, "Signup"),
            ],
          ),
        ),
      ),
    );
  }
}

//

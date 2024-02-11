import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/LoginScreen.dart';
import 'UiHelper.dart';

class OTPScreen extends StatefulWidget {
  String verificationid;
  OTPScreen({super.key, required this.verificationid});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text("Please enter the OTP"),
            const SizedBox(height: 30),
            UiHelper.customTextField(
                otpController, "Enter the obtained OTP.", false, true),
            const SizedBox(
              height: 30,
            ),
            UiHelper.customButtom(() async {
              try {
                PhoneAuthCredential credential =
                    PhoneAuthProvider.credential(
                        verificationId: widget.verificationid,
                        smsCode: otpController.text.toString());
                FirebaseAuth.instance.signInWithCredential(credential).then((value){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
                }
                );
              } catch (ex) {
                print(ex.toString());
              }
            }, "Verify"),
          ],
        ),
      ),
    );
  }
}

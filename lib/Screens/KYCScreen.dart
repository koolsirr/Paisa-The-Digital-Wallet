
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/KYC/Face%20Verification/Face.dart';
import 'package:majorproject_paisa/KYC/OCR/OCR.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({super.key});

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {

  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('KYC Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'))),
                padding: EdgeInsets.only(
                  top: 300,
                  left: 20,
                  right: 20,
                ),
              ),
              Text(
                'Please Enter your Email to start the KYC procedure',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Email',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              UiHelper.customTextField(
                emailController,
                "Please Enter your E-Mail",
                false,
                false,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 48)),
                  backgroundColor:
                  const MaterialStatePropertyAll(Colors.blueAccent),
                ),
                onPressed: () {
                  String email = emailController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaceVerification(enteredEmail: email),
                    ),
                  );
                },
                child: Text(
                  'Go to Face Verification',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
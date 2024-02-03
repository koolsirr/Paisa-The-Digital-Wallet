import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/LoginScreen.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> signUp(String email, String password, String fullName) async {
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      UiHelper.customAlertbox(context, "Please fill the form");
      return;
    }
    UserCredential? usercredential;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Add user data to Firestore with email as the document ID
      await FirebaseFirestore.instance.collection('Users').doc(email).set({
        'Email': email,
        'Full Name': fullName,
        // Add any other user-related data
      });

      // Navigate to the next screen (replace current screen)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (ex) {
      UiHelper.customAlertbox(context, "Registration failed: ${ex.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ))),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 16),
                const Text('Please fill up the Form'),
                const SizedBox(height: 32),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        nameController,
                        "Please Enter your Name",
                        false,
                        false,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        emailController,
                        "Please Enter your E-Mail",
                        false,
                        false,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        passwordController,
                        "Please Enter your Password",
                        true,
                        false,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                UiHelper.customButtom(() {
                  signUp(emailController.text, passwordController.text,
                      nameController.text);
                }, "Signup"),
                // UiHelper.customButtom(() {
                //   signUp(emailController.text.toString(),
                //       passwordController.text.toString());
                // }, "Signup")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

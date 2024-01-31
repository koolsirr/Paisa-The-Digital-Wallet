import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject_paisa/Screens/LoginScreen.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';

import 'HomeScreen.dart';
import 'PhoneNumber.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController nameController=TextEditingController();

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
            MaterialPageRoute(builder: (context) => const LoginScreen())
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // SvgPicture.asset('assets/logo/logo.svg'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                      UiHelper.customTextField(nameController, "Please Enter your Name", false),
                      const SizedBox(height: 24),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(emailController, "Please Enter your E-Mail", false),
                      const SizedBox(height: 24),
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(passwordController, "Please Enter your Password", true),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
            UiHelper.customButtom(() {
              signUp(emailController.text.toString(),passwordController.text.toString());
            }, "Signup")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
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
  TextEditingController userNameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController metroController = TextEditingController();
  TextEditingController wardController = TextEditingController();

  signUp(String email, String password) async {
    if (email == "" && password == "") {
      UiHelper.customAlertbox(context, "Please fill the form");
    }
    UserCredential? usercredential;
    try {
      usercredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                        'Citizenship No.',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        nameController,
                        "Please Enter your Citizenship No.",
                        false,
                        false,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Date of Birth (AD)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: UiHelper.customTextField(
                            yearController,
                            "Year",
                            false,
                            true,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: UiHelper.customTextField(
                            monthController,
                            "Month",
                            false,
                            true,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: UiHelper.customTextField(
                            dateController,
                            "Date",
                            false,
                            true,
                          ),
                        )
                      ]),
                      const SizedBox(height: 24),
                      Text(
                        'Birth Place',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: UiHelper.customTextField(
                            districtController,
                            "District",
                            false,
                            false,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: UiHelper.customTextField(
                            metroController,
                            "Metropolitan",
                            false,
                            false,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: UiHelper.customTextField(
                            wardController,
                            "Ward No.",
                            false,
                            true,
                          ),
                        )
                      ]),
                      const SizedBox(height: 24),
                      Text(
                        'User Name',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        userNameController,
                        "Please Enter your User Name",
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
                  signUp(emailController.text.toString(),
                      passwordController.text.toString());
                }, "Signup")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

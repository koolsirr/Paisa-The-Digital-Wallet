import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';

import 'LoginScreen.dart';
import 'OTP.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isValidNumeric(String value) {
    return int.tryParse(value) != null;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController citizenController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController metroController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  TextEditingController reEnterPinController = TextEditingController();

  signUp(String email, String password, String fullName) async {
    UserCredential? usercredential;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      UiHelper.customAlertbox(context, "Registration failed: ${ex.message}");
    }
  }

  addData(
    String name,
    String citizen,
    String year,
    String month,
    String day,
    String district,
    String metro,
    String ward,
    String email,
    String phoneNumber,
    String pin,
  ) async {
    if (email.isEmpty ||
        name.isEmpty ||
        citizen.isEmpty ||
        !isValidNumeric(year) ||
        !isValidNumeric(month) ||
        !isValidNumeric(day) ||
        district.isEmpty ||
        metro.isEmpty ||
        ward.isEmpty ||
        phoneNumber.isEmpty) {
      UiHelper.customAlertbox(context, "Please fill the form");
    }
    await FirebaseFirestore.instance.collection("Users").doc(email).set({
      "Full Name": name,
      "Citizenship Certificate No": citizen,
      "Year": year,
      "Month": month,
      "Day": day,
      "District": district,
      "Metropolitan": metro,
      "Ward No": ward,
      "Email": email,
      "Balance": 0,
      "Phone Number": phoneNumber,
      "Transaction Pin": pin,
    });
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
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
                        citizenController,
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
                        const SizedBox(width: 15),
                        Expanded(
                          child: UiHelper.customTextField(
                            monthController,
                            "Month",
                            false,
                            true,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: UiHelper.customTextField(
                            dayController,
                            "Day",
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
                        const SizedBox(width: 15),
                        Expanded(
                          child: UiHelper.customTextField(
                            metroController,
                            "Metropolitan",
                            false,
                            false,
                          ),
                        ),
                        const SizedBox(width: 15),
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
                        'Phone Number',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        phoneNumberController,
                        "Please Enter your Phone Number",
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
                      Text(
                        'Re-Enter Password',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        reEnterPasswordController,
                        "Please Re-Enter your Password",
                        true,
                        false,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Transaction pin',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: pinController,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          hintText: 'Enter your transaction pin',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Re-Enter Transaction pin',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: reEnterPinController,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          hintText: 'Please Re-Enter your transaction pin',
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                UiHelper.customButtom(() async {
                  if (passwordController.text != reEnterPasswordController.text) {
                    UiHelper.customAlertbox(context, "Passwords do not match");
                    return;
                  }

                  if (pinController.text != reEnterPinController.text) {
                    UiHelper.customAlertbox(context, "PINs do not match");
                    return;
                  }
                  await FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException ex) {},
                      codeSent: (String verificationid, int? resendtoken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                      verificationid: verificationid,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      phoneNumber: phoneNumberController.text.toString());
                  signUp(emailController.text, passwordController.text,
                      nameController.text);
                  addData(
                      nameController.text.toString(),
                      citizenController.text.toString(),
                      yearController.text.toString(),
                      monthController.text.toString(),
                      dayController.text.toString(),
                      districtController.text.toString(),
                      metroController.text.toString(),
                      wardController.text.toString(),
                      emailController.text.toString(),
                      phoneNumberController.text.toString(),
                      pinController.text.toString(),
                  );
                }, "Signup"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

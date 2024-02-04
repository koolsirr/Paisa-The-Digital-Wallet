import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UiHelper.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
  addData(String name, String citizen, String year, String month, String day,
      String district, String metro, String ward, String email) async {
    if (email.isEmpty ||
        name.isEmpty ||
        citizen.isEmpty ||
        !isValidNumeric(year) ||
        !isValidNumeric(month) ||
        !isValidNumeric(day) ||
        district.isEmpty ||
        metro.isEmpty ||
        ward.isEmpty) {
      UiHelper.customAlertbox(context, "Please fill the form");
    }
    await FirebaseFirestore.instance.collection("Users").doc(email).set({
      "Full Name": name,
      "Citizenship No.": citizen,
      "Year": year,
      "Month": month,
      "Day": day,
      "District": district,
      "Metropolitan": metro,
      "Ward No.": ward,
      "Email": email,
    });
    Navigator.pop(context);
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
                  'Update Profile',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 16),
                const Text('Please fill up the Form to update your profile'),
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
                            "day",
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
                    ],
                  ),
                ),
                UiHelper.customButtom(() {
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
                  );
                }, "Update Profile")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

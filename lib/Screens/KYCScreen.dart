import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majorproject_paisa/KYC/Face%20Verification/Face.dart';
import 'package:majorproject_paisa/Screens/HomeScreen.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';
import 'FetchUserData.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  File? frontImage;
  File? backImage;
  String? frontUrl;
  String? backUrl;
  TextEditingController emailController = TextEditingController();

  uploadData() async {
    await _uploadImage(frontImage, 'CitizenshipFront');
    await _uploadImage(backImage, 'CitizenshipBack');

    FirebaseFirestore.instance
        .collection("Users")
        .doc(emailController.text.toString())
        .update(
      {
        "Citizenship Front": frontUrl,
        "Citizenship Back": backUrl,
      },
    ).then((value) {
      print("User data Uploaded");
    });
  }

  Future<void> _uploadImage(File? image, String folderName) async {
    if (image != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(folderName)
          .child(emailController.text.toString())
          .putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      if (folderName == 'CitizenshipFront') {
        frontUrl = await taskSnapshot.ref.getDownloadURL();
      } else if (folderName == 'CitizenshipBack') {
        backUrl = await taskSnapshot.ref.getDownloadURL();
      }
    }
  }

  showAlertBox(String folderName) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick Image From:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera, folderName);
                  Navigator.pop(context);
                },
                leading: const Icon(Iconsax.camera),
                title: const Text("Camera"),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery, folderName);
                  Navigator.pop(context);
                },
                leading: const Icon(Iconsax.gallery),
                title: const Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Documents'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload your Documents here',
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
              Text(
                'Citizenship Front',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 15),
              InkWell(
                child: frontImage != null
                    ? Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(frontImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : frontUrl != null
                    ? Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(frontUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: const Icon(
                    Iconsax.add,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  showAlertBox('CitizenshipFront');
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Citizenship Back',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 15),
              InkWell(
                child: backImage != null
                    ? Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(backImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : backUrl != null
                    ? Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(backUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: const Icon(
                    Iconsax.add,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  showAlertBox('CitizenshipBack');
                },
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
                  String enteredEmail = emailController.text;
                  uploadData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaceVerification(enteredEmail: enteredEmail),
                    ),
                  );
                },
                child: Text(
                  'Go to Face Verification',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource, String folderName) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;
      final tempImage = File(photo.path);

      if (folderName == 'CitizenshipFront') {
        setState(() {
          frontImage = tempImage;
        });
      } else if (folderName == 'CitizenshipBack') {
        setState(() {
          backImage = tempImage;
        });
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majorproject_paisa/Screens/HomeScreen.dart';
import 'package:majorproject_paisa/Screens/UiHelper.dart';

import 'FetchUserData.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String? userEmail;
  File? pickedImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function during initialization
  }


  uploadData()async{
    UploadTask uploadTask=FirebaseStorage.instance.ref("Profile Pics").child(userEmail.toString()).putFile(pickedImage!);
    TaskSnapshot taskSnapshot=await uploadTask;
    String url=await taskSnapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection("Users").doc(userEmail.toString()).update(
        {
          "Image": url
        }).then((value) {
          print("user Uploaded");
    });
  }
  Future<void> _fetchUserData() async {
    userEmail = await UserDataService.fetchUserData('Email');
    imageUrl = await UserDataService.fetchUserData('Image');
    setState(() {});
  }

  showAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick Image From:"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  leading: Icon(Iconsax.camera),
                  title: Text("Camera"),
                ),
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  leading: Icon(Iconsax.gallery),
                  title: Text("Gallery"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: imageUrl != null
                ? CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(imageUrl!), // Display uploaded image if available
            )
                : CircleAvatar(
                    radius: 80,
                    child: Icon(
                      Iconsax.user,
                      size: 80,
                    ),
                  ),
            onTap: () {
              showAlertBox();
            },
          ),
          UiHelper.customButtom(() {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeScreen()));
            uploadData();
          }, "Upload Pic"),
        ],
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      print(ex.toString());
    }
  }
}

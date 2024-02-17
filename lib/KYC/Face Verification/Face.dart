import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majorproject_paisa/Screens/KYCScreen.dart';
import 'package:majorproject_paisa/Screens/LoginScreen.dart';

import '../OCR/OCR.dart';


class FaceVerification extends StatefulWidget {
  var enteredEmail;

  FaceVerification({super.key, required this.enteredEmail});

  @override
  State<FaceVerification> createState() => _FaceVerificationState();
}

class _FaceVerificationState extends State<FaceVerification> {
  String? front;
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  var img1 = Image.asset('assets/images/document.png');
  var img2 = Image.asset('assets/images/portrait.png');
  String? userEmail;
  String? imageUrl;
  String _similarity = "nil";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {
        print("Init failed: ");
        print(json);
      }
    });
  }

  showAlertDialog(BuildContext context, bool first) => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text("Use Camera?"),
      actions: [
        TextButton(
          child: const Row(
            children: [
              Icon(Iconsax.tick_circle,color: Colors.black), // Add a check icon
              SizedBox(width: 8.0), // Add some spacing between the icon and text
              Text("Yes",style: TextStyle(
                color: Colors.black
              )),
            ],
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            ImagePicker()
                .pickImage(source: ImageSource.camera)
                .then((value) => {
              setImage(
                  first,
                  io.File(value!.path).readAsBytesSync(),
                  Regula.ImageType.PRINTED)
            });
          },
        ),
      ],
    ),
  );

  setImage(bool first, Uint8List? imageFile, int type) {
    if (imageFile == null) return;
    setState(() => _similarity = "nil");
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        img1 = Image.memory(imageFile);
      });
    } else {
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      setState(() => img2 = Image.memory(imageFile));
    }
  }

  matchFaces() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    setState(() => _similarity = "Processing...");
    var request = new Regula.MatchFacesRequest();
    request.images = [image1, image2];
    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75)
          .then((str) {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));
        setState(() => _similarity = split!.matchedFaces.length > 0
            ? ((split.matchedFaces[0]!.similarity! * 100)
            .toStringAsFixed(2) +
            "%")
            : "error");
      });
    });
  }

  // Function to check if the button should be enabled
  bool isButtonEnabled() {
    double similarity = double.tryParse(_similarity.replaceAll("%", "")) ?? 0;
    return similarity > 77;
  }

  // Function to handle button press
  void _handleButtonPress() {
    var enteredEmail = widget.enteredEmail;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OCR(enteredEmail: enteredEmail), // Replace YourSeparatePage with your actual page
      ),
    );
  }

  Widget createButton(String text, VoidCallback onPress) => Container(
    width: 250,
    child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
        ),
        onPressed: onPress,
        child: Text(text)),
  );

  Widget createImage(image, VoidCallback onPress) => Material(
    child: InkWell(
      onTap: onPress,
      child: Container(
        height: 200,
        width: double.infinity,
        child: Image(height: 150, width: 150, image: image),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text('Face Verification'),
      leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const KYCScreen()));
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ))),
    ),
    body: SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${widget.enteredEmail}'),
                  SizedBox(height: 10,),
                  Text('Please upload the required images',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Citizenship Front'),
                  SizedBox(height: 10),
                  Container(
                    height: 220,
                    width: double.infinity,
                    child: createImage(
                        img1.image, () => showAlertDialog(context, true)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Your Photo'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 220,
                    width: double.infinity,
                    child: createImage(
                        img2.image, () => showAlertDialog(context, false)),
                  ),
                  Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15)),
                  createButton("Match", () => matchFaces()),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Similarity: " + _similarity,
                              style: TextStyle(fontSize: 18)),
                        ],
                      )),
                  SizedBox(height: 20,),
                  if (isButtonEnabled())
                    createButton("Proceed to OCR", () => _handleButtonPress()),
                ]),
          )),
    ),
  );
}

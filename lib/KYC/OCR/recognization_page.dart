import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:majorproject_paisa/KYC/OCR/FetchData.dart';
import 'package:document_analysis/document_analysis.dart';
import 'package:majorproject_paisa/Screens/LoginScreen.dart';
import 'package:majorproject_paisa/Screens/WelcomeScreen.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../Screens/FetchUserData.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  var enteredEmail;
  RecognizePage({super.key, this.path, required this.enteredEmail});

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  bool _Busy = false;
  TextEditingController ocrController = TextEditingController();
  String? userName;
  String? userCitizen;
  String? district;
  String? metro;
  String? ward;
  String? year;
  String? month;
  String? day;
  String? userInfo;
  String? extractedInfo;
  bool Similarity = false;

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _Busy = true;
      });

      userName = await FetchData.fetchData(widget.enteredEmail, 'Full Name');
      userCitizen = await FetchData.fetchData(widget.enteredEmail, 'Citizenship Citizenship No');
      district = await FetchData.fetchData(widget.enteredEmail, 'District');
      metro = await FetchData.fetchData(widget.enteredEmail, 'Metropolitan');
      ward = await FetchData.fetchData(widget.enteredEmail, 'Ward No');
      year = await FetchData.fetchData(widget.enteredEmail, 'Year');
      month = await FetchData.fetchData(widget.enteredEmail, 'Month');
      day = await FetchData.fetchData(widget.enteredEmail, 'Day');
      userInfo = 'Full name: $userName '
          'Citizenship Certificate No: $userCitizen '
          'District: $district '
          'Metropolitan: $metro '
          'Ward No: $ward '
          'Year: $year '
          'Month: $month '
          'Day: $day ';
      extractedInfo = ocrController.text;
    } finally {
      setState(() {
        _Busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("OCR Verification")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      const Text(
                        'User Data stored in database',
                        style: TextStyle(fontSize: 20,),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1,),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('$userInfo'),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        'User Data extracted from uploaded Document',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(ocrController.text.toString()
                              ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      // Text(
                      //     "Similarity = ${wordFrequencySimilarity(userInfo!, extractedInfo!, distanceFunction: cosineDistance) * 100}%"),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 48)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                        ),
                        onPressed: () {
                          setState(() {
                            Similarity = true;
                          });
                        },
                        child: const Text('Show Similarity',style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                      const SizedBox(height: 10),
                      if (Similarity)
                        Text(
                          "similarity = ${(StringSimilarity.compareTwoStrings(userInfo, extractedInfo)*100)}%"
                        ),
                      const SizedBox(height: 10),
                      if(Similarity)
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 48)),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                              ),
                            );
                          },
                          child: const Text('KYC Verification Successful!',style: TextStyle(color: Colors.white),),
                        ),
                    ],
                  ),
                ),
              ));
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    ocrController.text = recognizedText.text;

    setState(() {
      _isBusy = false;
    });
  }
}

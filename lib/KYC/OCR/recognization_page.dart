import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:majorproject_paisa/KYC/OCR/FetchData.dart';

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
  TextEditingController ocrController = TextEditingController();
  String? userName;
  String? userEmail;
  String? phoneNumber;
  String? metro;

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
    _fetchData();
  }

  Future<void> _fetchData()async{
    userName = await FetchData.fetchData(widget.enteredEmail, 'Full Name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("recognized page")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('$userName'),
                      Text(
                        ocrController.text.toString()
                        // maxLines: MediaQuery.of(context).size.height.toInt(),
                        // controller: ocrController,
                        // decoration:
                        //     const InputDecoration(hintText: "Text goes here..."),
                      ),
                    ],
                  ),
                ),
            ));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Recognized Page")),
  //     body: _isBusy
  //         ? const Center(
  //       child: CircularProgressIndicator(),
  //     )
  //         : Container(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Recognized Text:',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 10),
  //           Text(
  //             ocrController.text ?? 'No text recognized',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           const SizedBox(height: 20),
  //           Text(
  //             'User Full Name:',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 10),
  //           Text(
  //             fullName.isNotEmpty ? fullName : 'No user data available',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    ocrController.text = recognizedText.text;

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }


}

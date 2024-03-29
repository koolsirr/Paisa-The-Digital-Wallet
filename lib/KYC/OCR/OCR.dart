import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majorproject_paisa/KYC/OCR/recognization_page.dart';

import 'image_cropper_page.dart';
import 'image_picker_class.dart';
import 'modal_dialog.dart';

class OCR extends StatefulWidget {
  var enteredEmail;
  OCR({Key? key, required this.enteredEmail}) : super(key: key);

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  var img2 = Image.asset('assets/images/document.png');
  String? selectedImagePath;
  String? Email;

  Widget createImage(image, VoidCallback onPress) => Material(
        child: InkWell(
          onTap: onPress,
          child: Container(
            height: 200,
            width: double.infinity,
            child: Image(height: 150, width: 150, image: image),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${widget.enteredEmail}'),
            const SizedBox(height: 10),
            const Text('Please upload the required images',style: TextStyle(
              fontSize: 20
            )),
            const Text('*Crop the image for better result',style: TextStyle(
              fontSize: 15
            )),
            const SizedBox(height: 100),
            const Text('Citizenship Back'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                imagePickerModal(context, onCameraTap: () {
                  pickImage(source: ImageSource.camera).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then((value) {
                        if (value != '') {
                          Email = widget.enteredEmail;
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => RecognizePage(
                                path: value,
                                  enteredEmail: Email
                              ),
                            ),
                          );
                        }
                      });
                    }
                  });
                });
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/document.png', // Replace with your image path
                      // width: 200.0, // Adjust the width as needed
                      height: 150.0, // Adjust the height as needed
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

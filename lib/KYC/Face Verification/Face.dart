import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:image_picker/image_picker.dart';
import 'package:majorproject_paisa/Screens/KYCScreen.dart';


class FaceVerification extends StatefulWidget {
  var enteredEmail; //widget.enteredEmail garera use garne
  FaceVerification({super.key, required this.enteredEmail});

  @override
  State<FaceVerification> createState() => _FaceVerificationState();
}

class _FaceVerificationState extends State<FaceVerification> {

  String? front;
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  var img1 = Image.asset('assets/images/logo.png');
  var img2 = Image.asset('assets/images/portrait.png');
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
      builder: (BuildContext context) =>
          AlertDialog(title: Text("Use Camera?"), actions: [
            // ignore: deprecated_member_use
            // TextButton(
            //     child: Text("Use gallery"),
            //     onPressed: () {
            //       Navigator.of(context, rootNavigator: true).pop();
            //       ImagePicker()
            //           .pickImage(source: ImageSource.gallery)
            //           .then((value) => {
            //         setImage(
            //             first,
            //             io.File(value!.path).readAsBytesSync(),
            //             Regula.ImageType.PRINTED)
            //       });
            //     }),
            // // ignore: deprecated_member_use
            TextButton(
                child: Text("Use camera"),
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
                }
                )
          ]));

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
            ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) +
            "%")
            : "error");
      });
    });
  }


  Widget createButton(String text, VoidCallback onPress) => Container(
    // ignore: deprecated_member_use
    width: 250,
    // ignore: deprecated_member_use
    child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
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
        ),
      ));


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
                        builder: (context) => const KYCScreen()
                        ));
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ))),
    ),
    body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Citizenship Front'),
                SizedBox(height: 10),
                createImage(img1.image, () => showAlertDialog(context, true)),
                SizedBox(height: 10,),
                Text('Your Photo'),
                SizedBox(height: 10,),
                createImage(img2.image, () => showAlertDialog(context, false)),
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
                    ))
              ]),
        )),
  );

}

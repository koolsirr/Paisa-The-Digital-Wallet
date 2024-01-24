import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper{
  static customTextField(TextEditingController controller,String text, bool toHide) {
    return TextFormField(
      controller: controller,
      obscureText: toHide,
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: text,
      ),
    );
  }
  static customButtom(VoidCallback voidCallback,String text){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 48)),
            backgroundColor: const MaterialStatePropertyAll(Colors.blueAccent)
        ),
        onPressed: () {
          voidCallback();
        },
        child: Text(text,style:
        TextStyle(color: Colors.white)),
      ),
    );
  }
  static customAlertbox(BuildContext context,String text){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text(text),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("ok"))
        ],
      );

    });

  }
}


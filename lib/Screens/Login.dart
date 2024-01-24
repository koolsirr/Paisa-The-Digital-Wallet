import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/Statements.dart';
import 'package:majorproject_paisa/Screens/signup.dart';
import 'package:majorproject_paisa/Screens/uihelper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  login(String email,String password)async{
    if(email=="" && password==""){
      return UiHelper.customAlertbox(context, "Empty");
    }
    else{
      UserCredential? usercredential;
      try{
        usercredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Statement()));
        });
      }
      on FirebaseAuthException catch(ex){
        return UiHelper.customAlertbox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.customTextField(emailController, "Please Enter your E-Mail", false),
          UiHelper.customTextField(passwordController, "Please Enter your Password", true),
          SizedBox(height: 30),
          UiHelper.customButtom(() { 
            login(emailController.text.toString(), passwordController.text.toString());
          }, "Log in"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
              }, child: Text("signup"))
            ],
          )

        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:majorproject_paisa/KYC/OCR/OCR.dart';
import 'package:majorproject_paisa/Screens/ForgotPassword.dart';
import 'package:majorproject_paisa/Screens/KYCScreen.dart';
import 'package:majorproject_paisa/Screens/LoadMoney.dart';
import 'package:majorproject_paisa/Screens/CheckUser.dart';
import 'package:majorproject_paisa/Screens/SendMoney.dart';
import 'package:majorproject_paisa/Screens/ShowData.dart';
import 'KYC/Face Verification/Face.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/NotificationPage.dart';
import 'Screens/OTP.dart';
import 'Screens/PhoneNumber.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/RegisterScreen.dart';
import 'Screens/Statements.dart';
import 'Screens/UpdateProfile.dart';
import 'Screens/VerificationPage.dart';
import 'Screens/WelcomeScreen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

bool hidePassword = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "Poppins",
            appBarTheme: const AppBarTheme(color: Colors.transparent),
            inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)))),
        initialRoute: 'KYC',
        routes: {
          'welcome': (context) => const WelcomeScreen(),
          'login': (context) => const LoginScreen(),
          'register': (context) => const RegisterScreen(),
          'home': (context) => const HomeScreen(),
          'notification': (context) => const NotificationPage(),
          'phone': (context) => const PhoneNumber(),
          'verify': (context) => const VerificationPage(),
          'profile': (context) => const ProfilePage(),
          'statement': (context) => const Statement(),
          'check' : (context) => const CheckUser(),
          'forgot' : (context) => const ForgotPassword(),
          'send' : (context) => const SendMoney(),
          'load' : (context) => const LoadMoney(),
          'show' : (context) => const ShowData(),
          'update' : (context) => const UpdateProfile(),
          'KYC' :(context) => const KYCScreen(),

        }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:majorproject_paisa/Screens/Login.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/NotificationPage.dart';
import 'Screens/PhoneNumber.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/RegisterScreen.dart';
import 'Screens/Statements.dart';
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
        initialRoute: 'welcome',
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
        }
    );
  }
}
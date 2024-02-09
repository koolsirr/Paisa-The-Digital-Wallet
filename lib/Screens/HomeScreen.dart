import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'FetchUserData.dart';
import 'MainScreen.dart';
import 'NotificationPage.dart';
import 'ProfilePage.dart';
import 'Statements.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  String? userName;
  String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    UserDataService.onUserDataUpdated = _fetchUserData;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userName = await UserDataService.fetchUserData('Full Name');
    setState(() {});
  }

  final List<Widget> _screens = [
    const Statement(),
    const MainScreen(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Hi, $userName'),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationPage()));
                  },
                  icon: const Icon(Iconsax.notification))),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const CupertinoIconThemeData(color: Colors.black),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 500),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.greenAccent,
        color: Colors.blueAccent,
        index: _currentIndex,
        height: 55.0,
        items: const <Widget>[
          Icon(Iconsax.book_1, size: 30),
          Icon(Iconsax.home, size: 30),
          Icon(Iconsax.profile_circle, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

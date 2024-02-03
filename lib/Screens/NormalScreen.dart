// _user_profile.dart

import 'package:flutter/material.dart';

import 'FetchUserData.dart';
import 'MainScreen.dart';
import 'ProfilePage.dart';
import 'Statements.dart'; // Import the data service file

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _currentIndex = 1;
  String? userName;
  String? districtName;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function during initialization
  }

  Future<void> _fetchUserData() async {
    userName = await UserDataService.fetchUserData('Full Name');
    districtName = await UserDataService.fetchUserData('District');

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
      appBar: AppBar(
        title: Text('Hi, $userName'),
        // actions: [
        //   if (userName != null)
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Text(userName!),
        //     ),
        //   if (districtName != null)
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Text(districtName!),
        //     ),
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display other user data or widgets as needed
            if (userName != null)
              Text('Welcome, $userName!'),
            if (districtName != null)
              Text('District: $districtName'),
            // SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _fetchUserData,
            //   child: Text('Fetch User Data from Firestore'),
            // ),
          ],
        ),
      ),
    );
  }
}

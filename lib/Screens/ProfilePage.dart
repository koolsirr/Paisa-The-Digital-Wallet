import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject_paisa/Screens/UpdateProfile.dart';
import 'FetchUserData.dart';
import 'WelcomeScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function during initialization
  }

  Future<void> _fetchUserData() async {
    userName = await UserDataService.fetchUserData('Full Name');
    userEmail = await UserDataService.fetchUserData('Email');

    setState(() {});
  }

  logout()async{
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>const WelcomeScreen() ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body:ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$userName',
                  style: TextStyle(color: Colors.black)),
              accountEmail: Text(
                "$userEmail",
                style: TextStyle(color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('assets/images/pic.png')),
              ),
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
             ListTile(
              leading: const Icon(Iconsax.document_upload),
              title: const Text('Update Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateProfile()));
              }
            ),
            ListTile(
              leading: const Icon(Iconsax.logout),
              title: const Text('Logout'),
              onTap: logout,
            ),
            const ListTile(
              leading: Icon(Iconsax.setting_2),
              title: Text('Settings'),
            ),
          ],
        ),
    );
  }
}

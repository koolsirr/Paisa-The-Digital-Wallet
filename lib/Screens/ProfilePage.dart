import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject_paisa/Screens/UpdateProfile.dart';
import 'LoginScreen.dart';
import 'WelcomeScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  logout() async {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Bishal Manandhar',
                style: TextStyle(color: Colors.black)),
            accountEmail: const Text(
              "Email.com",
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/images/pic.png')),
            ),
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
          const ListTile(
            leading: Icon(Iconsax.document_upload),
            title: Text('Update Profile'),
          ),
          ListTile(
            leading: const Icon(Iconsax.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateProfile()),
              );
            },
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

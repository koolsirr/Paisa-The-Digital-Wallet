import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'WelcomeScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body:ListView(
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
              title: Text('upload'),
            ),
            ListTile(
              leading: Icon(Iconsax.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
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

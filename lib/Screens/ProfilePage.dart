import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject_paisa/Screens/UpdateProfile.dart';
import 'FetchUserData.dart';
import 'VerificationPage.dart';
import 'WelcomeScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? userEmail;
  String? phoneNumber;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function during initialization
  }

  Future<void> _fetchUserData() async {
    userName = await UserDataService.fetchUserData('Full Name');
    userEmail = await UserDataService.fetchUserData('Email');
    phoneNumber = await UserDataService.fetchUserData('Phone Number');
    imageUrl = await UserDataService.fetchUserData('Image');

    setState(() {});
  }

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
            accountName: Text('$userName($phoneNumber) ',
                style: const TextStyle(color: Colors.black)),
            accountEmail: Text(
              "$userEmail",
              style: const TextStyle(color: Colors.black),
            ),
            currentAccountPicture: imageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                        imageUrl!), // Use the uploaded image if available
                  )
                : const CircleAvatar(
                    child: ClipOval(
                        child: Icon(Iconsax.user)), // Fall back to a default image
                  ),
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
          ListTile(
            leading: const Icon(Iconsax.logout),
            title: const Text('Logout'),
            onTap: logout,
          ),
          ListTile(
            leading: const Icon(Iconsax.user),
            title: const Text('Update Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfile()));
            },
          ),
        ],
      ),
    );
  }
}

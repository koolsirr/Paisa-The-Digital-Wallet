import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  static Function? onUserDataUpdated; // Callback function

  static Future<String?> fetchUserData(String fieldName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('Email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String? userData = querySnapshot.docs.first[fieldName] as String?;
          if (onUserDataUpdated != null) {
            onUserDataUpdated!();
          }
          return userData;
        } else {
          print("Document not found for user: ${user.email}");
          return null;
        }
      } else {
        print("User not authenticated");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';

class FetchData {
  static Function()? onUserDataUpdated; // Callback function

  static Future<String?> fetchData(String email, String fieldName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String? userData = querySnapshot.docs.first[fieldName] as String?;
        if (onUserDataUpdated != null) {
          onUserDataUpdated!();
        }
        return userData;

      } else {
        print("Document not found for email: $email");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
class FetchEmail {
  static Function()? onUserDataUpdated; // Callback function

  static Future<String?> fetchUserEmail(String email) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .get();

      if (userSnapshot.exists) {
        String? userEmail = userSnapshot.get('Email') as String?;
        if (onUserDataUpdated != null) {
          onUserDataUpdated!();
        }
        return userEmail;
      } else {
        print("Document not found for email: $email");
        return null;
      }
    } catch (e) {
      print("Error fetching user email: $e");
      return null;
    }
  }
}
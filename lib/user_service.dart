import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getUsername(String userId) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)  // Assuming userId is stored in SharedPreferences or another source
      .get();

  if (snapshot.exists) {
    return snapshot['username'];  // Fetching the 'username' field
  } else {
    return 'User not found';
  }
}
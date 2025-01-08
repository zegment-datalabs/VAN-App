import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  String? userName;
  String? profilePicPath;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is logged in
  _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      setState(() {
        isLoggedIn = true;
        userEmail = user.email;
      });
      _fetchUserData(user.uid); // Fetch user data from Firestore
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  // Fetch user details from Firestore
  _fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
          profilePicPath = userDoc['profileImageUrl'] ?? 'default-avatar-url'; // Default image URL if not found
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Function to logout
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data

    await FirebaseAuth.instance.signOut(); // Sign out from Firebase

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: isLoggedIn
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (profilePicPath != null)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profilePicPath!),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, $userName',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: $userEmail',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // button color
                      minimumSize: const Size(150, 50), // button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ), // Show loading indicator until the data is fetched
    );
  }
}

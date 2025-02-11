import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:van_app_demo/homepage.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  String _name = "";
  String _emailOrPhone = "";
   String _profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'User';
      _emailOrPhone = prefs.getString('emailOrphone') ?? 'Not Available';
       _profilePicUrl = prefs.getString('profilePicPath') ?? "";

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
    appBar: AppBar(
  title: Text("My Account"),
  backgroundColor: Colors.blueGrey,
  elevation: 0,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    },
  ),
),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicUrl.isNotEmpty
                      ? NetworkImage(_profilePicUrl)
                      : null, // No image if URL is empty
                  child: _profilePicUrl.isEmpty
                      ? Icon(Icons.person, size: 50, color: Colors.white) // Placeholder icon
                      : null, // No icon if URL is available
                  backgroundColor: Colors.grey.shade400, // Background color for the icon
                ),
                SizedBox(height: 10),
                Text(
                  _name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  _emailOrPhone,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              ),
              onPressed: () {
                // Navigate to edit profile page
              },
              child: Text("Edit Profile", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

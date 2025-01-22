import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  String? profilePicPath;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load the saved user data from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('emailPhone') ?? 'Guest';
      profilePicPath = prefs.getString('profilePicPath') ?? 'default-avatar-url';
    });
  }

  // Function to logout
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Function to add category data to Firestore
  void _addCategoryData() async {
    final categoryCollection = db.collection("category");

    try {
      final categories = [
        {"title": "Electronics", "icon": "electrical_services"},
        {"title": "Clothing", "icon": "shopping_bag"},
        {"title": "Books", "icon": "book"},
        {"title": "Shoes", "icon": "run_circle"},
        {"title": "Groceries", "icon": "local_grocery_store"},
      ];

      for (var category in categories) {
        await categoryCollection.doc(category["title"]).set(category);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category data successfully added!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding category data: $e')),
      );
    }
  }

  // Function to add product data to Firestore
  void _addProductData() async {
    final productCollection = db.collection("product");

    try {
      final products = [
        {"title": "Smartphone", "icon": "electrical_services"},
        {"title": "T-shirt", "icon": "shopping_bag"},
        {"title": "Novel", "icon": "book"},
        {"title": "Sneakers", "icon": "run_circle"},
        {"title": "Apple", "icon": "local_grocery_store"},
      ];

      for (var product in products) {
        await productCollection.doc(product["title"]).set(product);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product data successfully added!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product data: $e')),
      );
    }
  }

  // Function to load categories from Firestore
  void _loadCategories() async {
    final categoryCollection = db.collection("category");

    try {
      final snapshot = await categoryCollection.get();

      for (var doc in snapshot.docs) {
        final categoryData = doc.data();
        final title = categoryData['title'];
        final iconString = categoryData['icon']; // icon is a String

        // Safely cast the icon to String and map it
        if (iconString is String) {
          final icon = _getIconFromString(iconString); // Map string to actual Icon
          print('Category: $title, Icon: $icon');
        }
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Helper function to map string icon names to actual Icons
  Icon _getIconFromString(String iconString) {
    switch (iconString) {
      case 'electrical_services':
        return const Icon(Icons.electrical_services);
      case 'shopping_bag':
        return const Icon(Icons.shopping_bag);
      case 'book':
        return const Icon(Icons.book);
      case 'run_circle':
        return const Icon(Icons.run_circle);
      case 'local_grocery_store':
        return const Icon(Icons.local_grocery_store);
      default:
        return const Icon(Icons.help); // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
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
              'Welcome, $userEmail',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCategoryData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Category Data',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProductData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Product Data',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(150, 50),
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
      ),
    );
  }
}

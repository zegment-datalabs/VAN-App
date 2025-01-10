import 'dart:convert';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';  // For jsonDecode
import 'productspage.dart';
=======
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/productspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // for loading local JSON
>>>>>>> 0bc3cc35d19e5d197c036ba14d01be128290df17

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}
<<<<<<< HEAD
=======

class _CategoryPageState extends State<CategoryPage> {
  late List<Map<String, dynamic>> categories;
  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUserSignIn();
    _loadCategories();
  }

  // Check if the user is signed in
  void _checkUserSignIn() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      isUserSignedIn = user != null;
    });
  }

  // Load categories from the local JSON file
  Future<void> _loadCategories() async {
    // Replace with the path to your 'category.json' file
    final String response = await rootBundle.loadString('assets/category.json');
    final data = await json.decode(response);

    setState(() {
      categories = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserSignedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sign In First'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(child: Text('Please sign in to view categories')),
      );
    }
>>>>>>> 0bc3cc35d19e5d197c036ba14d01be128290df17

class _CategoryPageState extends State<CategoryPage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final String response = await rootBundle.loadString('assets/categories.json');
    final data = jsonDecode(response);
    setState(() {
      categories = data['categories']; // Assuming categories are stored under "categories"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.teal,
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
<<<<<<< HEAD
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final categoryTitle = category['title'] ?? 'Unknown Category';
                final categoryIcon = category['icon'] ?? '';
                
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsPage(
                            categoryTitle: categoryTitle,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconData(categoryIcon),
                          size: 40.0,
                          color: Colors.teal,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          categoryTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
=======
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to ProductsPage with the selected category
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductsPage(categoryTitle: category['title']),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            getIconFromString(category['icon']),
                            size: 40.0,
                            color: Colors.teal,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            category['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
>>>>>>> 0bc3cc35d19e5d197c036ba14d01be128290df17
            ),
    );
  }

<<<<<<< HEAD
  IconData _getIconData(String iconName) {
=======
  // Helper function to map icon name to IconData
  IconData getIconFromString(String iconName) {
>>>>>>> 0bc3cc35d19e5d197c036ba14d01be128290df17
    switch (iconName) {
      case 'Icons.electrical_services':
        return Icons.electrical_services;
      case 'Icons.shopping_bag':
        return Icons.shopping_bag;
<<<<<<< HEAD
      default:
        return Icons.category; // Default icon
=======
      case 'Icons.book':
        return Icons.book;
      case 'Icons.run_circle':
        return Icons.run_circle;
      case 'Icons.local_grocery_store':
        return Icons.local_grocery_store;
      case 'Icons.toys':
        return Icons.toys;
      case 'Icons.brush':
        return Icons.brush;
      case 'Icons.sports':
        return Icons.sports;
      case 'Icons.health_and_safety':
        return Icons.health_and_safety;
      case 'Icons.kitchen':
        return Icons.kitchen;
      case 'Icons.videogame_asset':
        return Icons.videogame_asset;
      case 'Icons.fastfood':
        return Icons.fastfood;
      case 'Icons.bookmark':
        return Icons.bookmark;
      case 'Icons.create':
        return Icons.create;
      case 'Icons.palette':
        return Icons.palette;
      case 'Icons.outdoor_grill':
        return Icons.outdoor_grill;
      case 'Icons.watch':
        return Icons.watch;
      case 'Icons.card_giftcard':
        return Icons.card_giftcard;
      default:
        return Icons.help;
>>>>>>> 0bc3cc35d19e5d197c036ba14d01be128290df17
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
=======
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/productspage.dart';
>>>>>>> 143520d3667accc8f80f64fff1a7795081692523

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
<<<<<<< HEAD
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isUserSignedIn = false;

  // Firestore Stream to listen for updates in the 'categories' collection
  final Stream<QuerySnapshot> _categoriesStream =
      FirebaseFirestore.instance.collection('categories').snapshots();

  @override
  void initState() {
    super.initState();
    _checkUserSignIn();
  }

  // Check if the user is signed in
  void _checkUserSignIn() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      isUserSignedIn = user != null;
    });
  }

  // Helper function to convert icon data
  IconData getIconData(dynamic iconField) {
    if (iconField is int) {
      return IconData(iconField, fontFamily: 'MaterialIcons');
    } else if (iconField is String) {
      // Add a map of string icon names to IconData
      final iconMap = {
        'book': Icons.book,
        'shopping_bag': Icons.shopping_bag,
        'help': Icons.help,
        // Add more string mappings here
      };
      return iconMap[iconField] ?? Icons.help;
    }
    return Icons.help; // Fallback icon
  }

  @override
=======
>>>>>>> 143520d3667accc8f80f64fff1a7795081692523
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.teal,
<<<<<<< HEAD
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoriesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                String categoryName = data['title'] ?? 'No Name';
                dynamic iconField = data['icon']; // This can be int or String

                // Convert iconField to IconData
                IconData categoryIcon = getIconData(iconField);

=======
        actions: [
          // HomePage Button in the AppBar
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Navigate to the HomePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('category').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No categories available.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
            );
          }

          final categories = snapshot.data!.docs;

          return Padding(
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
                final category = categories[index].data() as Map<String, dynamic>;
>>>>>>> 143520d3667accc8f80f64fff1a7795081692523
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
<<<<<<< HEAD
                      print('Category tapped: $categoryName');
=======
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsPage(
                            categoryTitle: category['title'] ?? 'No Title',
                          ),
                        ),
                      );
>>>>>>> 143520d3667accc8f80f64fff1a7795081692523
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
<<<<<<< HEAD
                        Icon(
                          categoryIcon,
=======
                        const Icon(
                          Icons.category, // Replace with a dynamic icon if stored in Firestore
>>>>>>> 143520d3667accc8f80f64fff1a7795081692523
                          size: 40.0,
                          color: Colors.teal,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
<<<<<<< HEAD
                          categoryName,
=======
                          category['title'] ?? 'No Title',
>>>>>>> 143520d3667accc8f80f64fff1a7795081692523
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
          );
        },
      ),
    );
  }
}

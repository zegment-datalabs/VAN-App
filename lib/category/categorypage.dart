import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.teal,
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

                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      print('Category tapped: $categoryName');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcon,
                          size: 40.0,
                          color: Colors.teal,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          categoryName,
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

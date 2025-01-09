import 'package:flutter/material.dart';
import 'package:van_app_demo/homepage.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define categories with titles and icons
    final List<Map<String, dynamic>> categories = [
      {'title': 'Electronics', 'icon': Icons.electrical_services},
      {'title': 'Clothing', 'icon': Icons.shopping_bag},
      {'title': 'Books', 'icon': Icons.book},
      {'title': 'Shoes', 'icon': Icons.run_circle},
      {'title': 'Groceries', 'icon': Icons.local_grocery_store},
      {'title': 'Toys', 'icon': Icons.toys},
      {'title': 'Beauty Products', 'icon': Icons.brush},
      {'title': 'Sports', 'icon': Icons.sports},
      {'title': 'Health', 'icon': Icons.health_and_safety},
      {'title': 'Home Appliances', 'icon': Icons.kitchen},
      {'title': 'Gaming', 'icon': Icons.videogame_asset},
      {'title': 'Food & Drink', 'icon': Icons.fastfood},
      {'title': 'Books & Magazines', 'icon': Icons.bookmark},
      {'title': 'Stationery', 'icon': Icons.create},
      {'title': 'Crafts', 'icon': Icons.palette},
      {'title': 'Outdoor & Adventure', 'icon': Icons.outdoor_grill},
      {'title': 'Watches', 'icon': Icons.watch},
      {'title': 'Gifts', 'icon': Icons.card_giftcard},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.teal,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Set to 3 to have 3 columns per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.0, // Keep the items square
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${category['title']}')),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'],
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
      ),
    );
  }
}
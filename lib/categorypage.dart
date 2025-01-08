import 'package:flutter/material.dart';

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
      {'title': 'Furniture', 'icon': Icons.chair},
      {'title': 'Toys', 'icon': Icons.toys},
      {'title': 'Beauty Products', 'icon': Icons.brush},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${category['title']}')),
                  );
                  // Navigate to category-specific page if required
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

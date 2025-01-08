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
      // Wholesale-related categories
      {'title': 'Bulk Electronics', 'icon': Icons.devices},
      {'title': 'Wholesale Clothing', 'icon': Icons.local_mall},
      {'title': 'Wholesale Books', 'icon': Icons.library_books},
      {'title': 'Wholesale Shoes', 'icon': Icons.shopping_cart},
      {'title': 'Wholesale Groceries', 'icon': Icons.storefront},
      {'title': 'Wholesale Furniture', 'icon': Icons.weekend},
      {'title': 'Wholesale Toys', 'icon': Icons.child_care},
      {'title': 'Wholesale Beauty Products', 'icon': Icons.face_retouching_natural},
      {'title': 'Wholesale Home Appliances', 'icon': Icons.kitchen},
      {'title': 'Wholesale Office Supplies', 'icon': Icons.business_center},
    
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

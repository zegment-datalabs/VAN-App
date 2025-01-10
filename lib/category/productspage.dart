import 'dart:convert';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final String categoryTitle;

  const ProductsPage({super.key, required this.categoryTitle});

<<<<<<< HEAD
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final Map<String, List<Map<String, dynamic>>> categoryProducts = {
    'Electronics': [
      {'name': 'Smartphone', 'price': 299.99, 'quantity': 0},
      {'name': 'Laptop', 'price': 799.99, 'quantity': 0},
      {'name': 'Headphones', 'price': 49.99, 'quantity': 0},
      // Add more products
    ],
    'Clothing': [
      {'name': 'T-Shirt', 'price': 19.99, 'quantity': 0},
      {'name': 'Jeans', 'price': 39.99, 'quantity': 0},
      // Add more products
    ],
    // Add more categories with their respective products
  };
=======
  Future<List<Map<String, dynamic>>> _loadProducts(BuildContext context) async {
    final String jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/products.json');
    final List<dynamic> productsJson = json.decode(jsonString);
    return productsJson
        .map((product) => product as Map<String, dynamic>)
        .toList()
        .where((product) => product['category'] == categoryTitle)
        .toList();
  }
>>>>>>> 0bc3cc35d19e5d197c036ba14d01be128290df17

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> products = categoryProducts[widget.categoryTitle] ?? [];

    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(widget.categoryTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // You can change this value to control the number of columns
            childAspectRatio: 0.75,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product['name'],
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('\$${product['price'].toStringAsFixed(2)}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (product['quantity'] > 0) {
                                product['quantity']--;
                              }
                            });
                          },
                        ),
                        Text('${product['quantity']}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              product['quantity']++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
=======
        title: Text(categoryTitle),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadProducts(context), // Pass context here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading products.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['name']),
                  
                  leading: const Icon(Icons.shopping_cart),
                );
              },
            );
          }
        },
>>>>>>> 0bc3cc35d19e5d197c036ba14d01be128290df17
      ),
    );
  }
}

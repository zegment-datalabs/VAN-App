import 'dart:convert';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final String categoryTitle;

  const ProductsPage({super.key, required this.categoryTitle});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
    );
  }
}

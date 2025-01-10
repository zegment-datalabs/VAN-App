import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  final String categoryTitle;

  const ProductsPage({super.key, required this.categoryTitle});

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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> products = categoryProducts[widget.categoryTitle] ?? [];

    return Scaffold(
      appBar: AppBar(
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
      ),
    );
  }
}

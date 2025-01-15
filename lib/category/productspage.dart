import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  final String categoryTitle;

  const ProductsPage({super.key, required this.categoryTitle});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // Controller map for each product
  Map<String, TextEditingController> controllers = {};
  List<Map<String, dynamic>> products = [];

  Future<void> _loadProducts(BuildContext context) async {
    // Only load products if they are not already loaded
    if (products.isEmpty) {
      final String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/products.json');
      final List<dynamic> productsJson = json.decode(jsonString);
      products = productsJson
          .map((product) => product as Map<String, dynamic>)
          .toList()
          .where((product) => product['category'] == widget.categoryTitle)
          .toList();

      // Initialize controllers for each product
      for (var product in products) {
        if (!controllers.containsKey(product['name'])) {
          controllers[product['name']] = TextEditingController(
              text: product['quantity']?.toString() ?? '0');
        }
      }
    }
  }

  // Debounce timer for manual quantity input
  Timer? _debounce;

  void _onQuantityChanged(String productName, String value) {
    // Cancel any previous debounce timer
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        final newQuantity = int.tryParse(value) ?? 0;
        controllers[productName]?.text =
            newQuantity < 0 ? '0' : newQuantity.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context); // Go back to home page
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _loadProducts(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading products.'));
          } else if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            return Column(
              children: [
                // Product List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final productName = product['name'];
                        final quantity = int.tryParse(
                                controllers[productName]?.text ?? '0') ??
                            0;

                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Product Name
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    productName,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Quantity Controller (- Button, Quantity Display, + Button)
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Less (-) Button
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle),
                                        color: Colors.red,
                                        onPressed: () {
                                          setState(() {
                                            if (quantity > 0) {
                                              controllers[productName]?.text =
                                                  (quantity - 1).toString();
                                            }
                                          });
                                        },
                                      ),
                                      // Quantity Display
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Add (+) Button
                                      IconButton(
                                        icon: const Icon(Icons.add_circle),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            controllers[productName]?.text =
                                                (quantity + 1).toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // Manual Quantity Input
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: controllers[productName],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Qty',
                                    ),
                                    onChanged: (value) {
                                      _onQuantityChanged(productName, value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.teal[100], // Set background color
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Space buttons evenly
                    children: [
                      // Buy Now Button
                      ElevatedButton(
                        onPressed: () {
                          // Add your action for 'Buy Now' here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Buy Now clicked')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Button color
                        ),
                        child: const Text('Buy Now'),
                      ),
                      // Add to Cart Button
                      ElevatedButton(
                        onPressed: () {
                          // Add your action for 'Add to Cart' here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to Cart')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

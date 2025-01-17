import 'package:flutter/material.dart';

class Cart {
  static final List<Map<String, dynamic>> selectedProducts = [];
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Cart.selectedProducts.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: Cart.selectedProducts.length,
              itemBuilder: (context, index) {
                final product = Cart.selectedProducts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 6.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal[100],
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Colors.teal,
                      ),
                    ),
                    title: Text(
                      product['title'] ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category: ${product['category'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                        ),
                        Text(
                          'Quantity: ${product['quantity']}',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              if (product['quantity'] > 1) {
                                product['quantity']--;
                              } else {
                                Cart.selectedProducts.removeAt(index);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              product['quantity']++;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              Cart.selectedProducts.removeAt(index);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item removed from cart')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

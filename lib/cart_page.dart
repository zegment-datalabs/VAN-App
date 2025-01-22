import 'package:flutter/material.dart';

class Cart {
<<<<<<< HEAD
=======
  // Store the selected products in the cart
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
  static final List<Map<String, dynamic>> selectedProducts = [];
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String searchQuery = '';
  bool isSearchVisible = false;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

=======
    // Update the search query as user types
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  // Calculate total price and total quantity
  double get totalPrice {
    double total = 0.0;
    for (var product in Cart.selectedProducts) {
      double price = double.tryParse(product['selling_price'].toString()) ?? 0.0;
      int quantity = product['quantity'] ?? 0;
      total += price * quantity;
    }
    return total;
  }

  int get totalQuantity {
    int total = 0;
    for (var product in Cart.selectedProducts) {
      total += product['quantity'] ?? 0 as int ;
    }
    return total;
=======
  // Calculate the total price of all products in the cart
 double calculateTotalAmount() {
  double total = Cart.selectedProducts.fold<double>(
    0.0,
    (total, product) {
      final quantity = product['quantity'] is int ? product['quantity'] : 0;
      final sellingPrice = double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0;
      return total + (quantity * sellingPrice);
    },
  );
  return total;
}


  // Calculate the total quantity of all products in the cart
  int calculateTotalQuantity() {
    return Cart.selectedProducts.fold<int>(
      0,
      (total, product) => total + (product['quantity'] ?? 0) as int,
    );
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    // Filter products based on search query
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
    final filteredProducts = Cart.selectedProducts.where((product) {
      final productTitle = product['title']?.toLowerCase() ?? '';
      return productTitle.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
                if (isSearchVisible) {
                  FocusScope.of(context).requestFocus(searchFocusNode);
                } else {
                  searchController.clear();
                  searchFocusNode.unfocus();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
<<<<<<< HEAD
=======
          // Search bar visibility toggle
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
          if (isSearchVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search in cart...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: searchFocusNode.hasFocus
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            searchFocusNode.unfocus();
                          },
                        )
                      : null,
                ),
              ),
            ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 5, 5),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
<<<<<<< HEAD
                      final sellingPrice = product['selling_price']?.toString() ?? '0.00'; // Fetch selling price
=======
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de

                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 0.0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
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
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
<<<<<<< HEAD
                                    'Quantity: ${product['quantity']}',
=======
                                    'Quantity: ${product['quantity'] ?? 0}',
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
<<<<<<< HEAD
                                  // Displaying the selling price under quantity
                                  Text(
                                    'Selling Price: \$ $sellingPrice',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.green[600],
                                    ),
                                  ),
=======
                                  
                                Text(
                                  '₹${(double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),


>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
<<<<<<< HEAD
=======
                                  // Decrement quantity or remove item
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.red),
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
<<<<<<< HEAD
=======
                                  // Increment quantity
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        product['quantity']++;
                                      });
                                    },
                                  ),
<<<<<<< HEAD
=======
                                  // Remove item from cart
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        Cart.selectedProducts.removeAt(index);
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Item removed from cart')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < filteredProducts.length - 1)
                            const Divider(
                              thickness: 1.0,
                              height: 1.0, // Tight space between items
                              color: Colors.black, // Black line color
                              indent: 0.0, // Full width
                              endIndent: 0.0, // Full width
                            ),
                        ],
                      );
                    },
                  ),
          ),
<<<<<<< HEAD
          // Footer Section with Total Price, Total Quantity, and Place Order button
          Padding(
=======
          // Footer with Total and Place Order Button
        Container(
            color: Colors.white,
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
<<<<<<< HEAD
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Quantity: $totalQuantity',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Place Order logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully!')),
=======
                Text(
                  'Total: ₹${calculateTotalAmount().toStringAsFixed(2)} | Qty: ${calculateTotalQuantity()}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 7, 7),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order Placed!')),
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
<<<<<<< HEAD
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
=======
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de

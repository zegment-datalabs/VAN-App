import 'package:flutter/material.dart';
import 'package:van_app_demo/category/allproducts.dart';
import 'category/order_page.dart';

class Cart {
  // Store the selected products in the cart
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
    // Update the search query as user types
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

  // Calculate the total price of all products in the cart
  double calculateTotalAmount() {
    return Cart.selectedProducts.fold<double>(
      0.0,
      (total, product) {
        final quantity = product['quantity'] is int ? product['quantity'] : 0;
        final sellingPrice = double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0;
        return total + (quantity * sellingPrice);
      },
    );
  }

  // Calculate the total quantity of all products in the cart
  int calculateTotalQuantity() {
    return Cart.selectedProducts.fold<int>(
      0,
      (total, product) => total + (product['quantity'] ?? 0) as int,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter products based on search query
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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllProductsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar visibility toggle
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
                                    'Quantity: ${product['quantity'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '₹${(double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Decrement quantity or remove item
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
                                  // Increment quantity
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        product['quantity']++;
                                      });
                                    },
                                  ),
                                  // Remove item from cart
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        Cart.selectedProducts.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < filteredProducts.length - 1)
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                              color: Colors.black,
                              indent: 0.0,
                              endIndent: 0.0,
                            ),
                        ],
                      );
                    },
                  ),
          ),
          // Footer with Total and Place Order Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ₹${calculateTotalAmount().toStringAsFixed(2)} | Qty: ${calculateTotalQuantity()}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 7, 7),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: Cart.selectedProducts.isEmpty
                          ? null
                          : () {
                              double orderValue = calculateTotalAmount();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderPage(
                                    orderValue: orderValue,
                                    quantity: orderValue,
                                    selectedProducts: Cart.selectedProducts,
                                    
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cart.selectedProducts.isEmpty
                            ? Colors.grey
                            : Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              //   const SizedBox(height: 16.0),
              //  // Show a list of the added products in the footer
              //   if (Cart.selectedProducts.isNotEmpty)
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Added Products:',
              //           style: TextStyle(
              //             fontSize: 14.0,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.teal,
              //           ),
              //         ),
              //         ...Cart.selectedProducts.map((product) {
              //           return Text(
              //             '${product['title']} x${product['quantity']}',
              //             style: TextStyle(
              //               fontSize: 14.0,
              //               color: Colors.grey[700],
              //             ),
              //           );
              //         }).toList(),
              //       ],
              //     ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

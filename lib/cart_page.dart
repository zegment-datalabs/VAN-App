import 'package:flutter/material.dart';
import 'package:van_app_demo/category/allproducts.dart';
import 'category/confirmation_page.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/categorypage.dart';
import 'package:van_app_demo/myaccount.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:van_app_demo/widgets/common_widgets.dart';

// Adjust the path as necessary

class Cart {
  // Store the selected products in the cart
  static final List<Map<String, dynamic>> selectedProducts = [];
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String searchQuery = '';
  bool isSearchVisible = false;
  int _selectedIndex = 2;
  String _username = "User";
  bool isLoading = true;
  String _profilePicUrl = "";

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _profilePicUrl = prefs.getString('profilePicPath') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load username from SharedPreferences

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

  // Calculate the total price of all products in the cart with 2 decimal places
  double calculateTotalAmount() {
    double totalAmount = Cart.selectedProducts.fold<double>(
      0.0,
      (total, product) {
        final quantity =
            (product['quantity'] as num?)?.toDouble() ?? 0.0; // Ensure double
        final sellingPrice =
            double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ??
                0.0;
        return total + (quantity * sellingPrice);
      },
    );
    return double.parse(
        totalAmount.toStringAsFixed(2)); // Ensure exactly 2 decimal places
  }

// Calculate the total quantity of all products in the cart with 2 decimal places
  String calculateTotalQuantity() {
    double totalQuantity = Cart.selectedProducts.fold<double>(
      0.0,
      (total, product) =>
          total +
          ((product['quantity'] as num?)?.toDouble() ?? 0.0), // Ensure double
    );
    return totalQuantity.toStringAsFixed(2); // Ensure exactly 2 decimal places
  }

  // Handle navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CategoryPage()),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
        break;
      case 3: // For All Products page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllProductsPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyAccountPage()),
        );
        break;
      default:
        break;
    }
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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text('Item Basket', style: TextStyle(color: Colors.white)),
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
          // The Add button to navigate to AllProductsPage
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllProductsPage()),
              );
            },
          ),
          // The Hamburger menu icon that opens the endDrawer
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Open the end drawer
              },
            ),
          ),
        ],
      ),

      /// **Custom Drawer**
      endDrawer: CustomDrawer(
        profilePicUrl: _profilePicUrl,
        username: _username,
        onItemTapped: _onItemTapped,
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
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.teal),
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
                                    '₹ Price-${(double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)}',
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
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 139, 28, 20),
                                    ),
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
                  ],
                ),
                const SizedBox(height: 10),
                
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    // Cancel Button - Clears the cart
    CustomButton(
      text: 'Cancel',
      onPressed: Cart.selectedProducts.isEmpty
          ? null
          : () {
              setState(() {
                Cart.selectedProducts.clear();
              });
            },
     backgroundColor: Cart.selectedProducts.isEmpty
          ? const Color.fromARGB(255, 209, 205, 205)
          : Colors.orangeAccent,
    ),

    const SizedBox(width: 10),

    // Place Order Button
    CustomButton(
      text: 'Place Order',
      onPressed: Cart.selectedProducts.isEmpty
          ? null
          : () {
              double orderValue = calculateTotalAmount();
              List<Map<String, dynamic>> orderedProducts =
                  List.from(Cart.selectedProducts);

              // Clear the cart before navigation
              setState(() {
                Cart.selectedProducts.clear();
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmationPage(
                    orderValue: orderValue,
                    quantity: calculateTotalAmount(),
                    selectedProducts: orderedProducts, // Pass a copy of the products
                  ),
                ),
              );
            },
      backgroundColor: Cart.selectedProducts.isEmpty
          ? const Color.fromARGB(255, 209, 205, 205)
          : const Color.fromARGB(255, 0, 150, 136),
    ),
  ],
),
              ],
            ),
          ),
        ],
      ),

      /// Use `CustomBottomNavigationBar`
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

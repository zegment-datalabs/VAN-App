import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:van_app_demo/cart_page.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/categorypage.dart';
import 'package:van_app_demo/myaccount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:van_app_demo/widgets/common_widgets.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  AllProductsPageState createState() => AllProductsPageState();
}

class AllProductsPageState extends State<AllProductsPage> {
  Map<String, TextEditingController> controllers = {};
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String searchQuery = '';
  String _username = "User"; // Default username
  String _profilePicUrl = "";
  bool isLoading = true;
  int _selectedIndex = 3;

  TextEditingController searchController =
      TextEditingController(); // Search functionality
  FocusNode searchFocusNode = FocusNode();

  // ScrollController for smooth scrolling
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _profilePicUrl = prefs.getString('profilePicPath') ?? "";
    });
  }

  Future<void> _loadProducts() async {
    setState(() {
      String username = 'User Name'; // Default nam
      isLoading = true;
    });

    final productCollection = FirebaseFirestore.instance.collection('product');

    try {
      final snapshot = await productCollection.get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          products = snapshot.docs.map((doc) => doc.data()).toList();
          filteredProducts = products;
        });

        // Sort products alphabetically by product title
        products.sort((a, b) {
          final titleA = a['title']?.toLowerCase() ?? '';
          final titleB = b['title']?.toLowerCase() ?? '';
          return titleA.compareTo(titleB);
        });

        // Initialize controllers for products
        for (var product in products) {
          final productName = product['title'] ?? 'Unknown';
          if (!controllers.containsKey(productName)) {
            controllers[productName] = TextEditingController(text: '0');
          }
        }
      }
    } catch (e) {
      print('Error loading products: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Prevent unnecessary navigation

    setState(() {
      _selectedIndex = index;
    });

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = const HomePage();
        break;
      case 1:
        nextPage = const CategoryPage();
        break;
      case 2:
        nextPage = const CartPage();
        break;
      case 3:
        return; // Already on AllProductsPage, do nothing
      case 4:
        nextPage = const MyAccountPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  // Function to filter products based on search query
  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
        filteredProducts = products.where((product) {
          final productName = product['title']?.toLowerCase() ?? '';
          return productName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  // Function to reset all quantities
  void _resetQuantities() {
    setState(() {
      controllers.forEach((key, controller) {
        controller.text = '0';
      });
    });
  }

  // Function to calculate the total amount
  double calculateTotalAmount() {
    double total = 0.0;

    for (var product in filteredProducts) {
      final productName = product['title'] ?? 'Unknown';
      final sellingPrice =
          double.tryParse(product['selling_price']?.toString() ?? '0.0') ?? 0.0;
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      total += sellingPrice * quantity;
    }

    return double.parse(
        total.toStringAsFixed(2)); // Ensure exactly 2 decimal places
  }

  Future<void> _addToGlobalCart() async {
    for (var product in filteredProducts) {
      final productName = product['title'] ?? 'Unknown';
      final sellingPrice =
          double.tryParse(product['selling_price']?.toString() ?? '0.00') ??
              0.0;
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      if (quantity > 0) {
        final existingIndex =
            Cart.selectedProducts.indexWhere((p) => p['title'] == productName);

        if (existingIndex >= 0) {
          Cart.selectedProducts[existingIndex]['quantity'] = quantity;
        } else {
          Cart.selectedProducts.add({
            'title': productName,
            'category': product['category'] ?? 'Unknown',
            'sellingPrice': sellingPrice,
            'quantity': quantity,
          });
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Products added to cart!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load username from SharedPreferences
    _loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'All Products',
        onHomePressed: () => _onItemTapped(0),
        onCartPressed: () {
          _resetQuantities();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CartPage()));
        },
      ),
      endDrawer: CustomDrawer(
        profilePicUrl: _profilePicUrl,
        username: _username,
        onItemTapped: _onItemTapped,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomSearchBar(
                    controller: searchController,
                    onSearch: _filterProducts,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final productName = product['title'] ?? 'Unknown';
                        final sellingPrice =
                            product['selling_price']?.toString() ?? '0.00';

                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productName,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '\$ $sellingPrice',
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(
                                              () {
                                                final currentQuantity =
                                                    int.tryParse(controllers[
                                                                    productName]
                                                                ?.text ??
                                                            '0') ??
                                                        0;
                                                if (currentQuantity > 0) {
                                                  controllers[productName]
                                                          ?.text =
                                                      (currentQuantity - 1)
                                                          .toString();
                                                }
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add,
                                              color: Colors.green),
                                          onPressed: () {
                                            setState(
                                              () {
                                                final currentQuantity =
                                                    int.tryParse(controllers[
                                                                    productName]
                                                                ?.text ??
                                                            '0') ??
                                                        0;
                                                controllers[productName]?.text =
                                                    (currentQuantity + 1)
                                                        .toString();
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 30.0,
                                      child: TextField(
                                        controller: controllers[productName],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Qty',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                        ),
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
  text: 'Buy Now',
  onPressed: () {
    _addToGlobalCart();
    _resetQuantities();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  },
  backgroundColor: Colors.deepOrange, // A vibrant orange for urgency
),

CustomButton(
  text: 'Add to Cart',
  onPressed: _addToGlobalCart,
  backgroundColor: Colors.teal, // A fresh teal shade for a modern look
),

                      ],
                    ),
                  ),
                ),
              ],
            ),
      // Use Custom Bottom Navigation
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

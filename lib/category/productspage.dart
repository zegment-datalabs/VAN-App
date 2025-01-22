import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:van_app_demo/cart_page.dart';
import 'package:van_app_demo/homepage.dart'; // Import the HomePage
import 'package:van_app_demo/category/categorypage.dart'; // Import the CategoryPage
import 'package:van_app_demo/category/order_page.dart';
import 'package:van_app_demo/category/allproducts.dart';

class ProductsPage extends StatefulWidget {
  final String categoryTitle;

  const ProductsPage({super.key, required this.categoryTitle});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Map<String, TextEditingController> controllers = {};
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;

  // Search functionality
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  // ScrollController for smooth scrolling
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    final productCollection = FirebaseFirestore.instance.collection('product');

    try {
      final snapshot = await productCollection
          .where('category', isEqualTo: widget.categoryTitle)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          products = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          filteredProducts = products; // Initially, all products are shown
        });

        // Sort products by product_id
        products.sort((a, b) {
          final idA = a['product_id'] ?? '';
          final idB = b['product_id'] ?? '';
          return idA.compareTo(idB); // Sorting lexicographically
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

  // Function to handle the search query
  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
        filteredProducts = products
            .where((product) {
              final productName = product['title']?.toLowerCase() ?? '';
              return productName.contains(query.toLowerCase());
            })
            .toList();
      });
    }
  }

  // Function to programmatically scroll
  void _scrollToPosition(double offset,
      {Duration? duration, Curve curve = Curves.easeInOut}) {
    _scrollController.animateTo(
      offset,
      duration: duration ?? const Duration(milliseconds: 200), // Adjust duration for speed control
      curve: curve,
    );
  }

  // Function to reset all quantities
  void _resetQuantities() {
    setState(() {
      controllers.forEach((key, controller) {
        controller.text = '0';
      });
    });
  }

   Future<void> _addToGlobalCart() async {
    for (var product in filteredProducts) {
      final productName = product['title'] ?? 'Unknown';
      final sellingPrice = double.tryParse(product['selling_price']?.toString() ?? '0.00') ?? 0.0;
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
    _loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with Cart Icon and Hamburger Menu (on the right side)
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: Colors.teal,
        actions: [
          // Cart Button
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Reset all quantities before navigating to the cart page
              _resetQuantities();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),

          // Hamburger Menu (on the right side)
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Open Drawer on the right side
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),

      // Drawer on the right side (simulated right drawer)
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
           const DrawerHeader(
              decoration:  BoxDecoration(
                color: Colors.teal,
              ),
              child:  Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Navigate to HomePage when "Home" is tapped
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                // Navigate to CategoryPage when "Categories" is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('All products'),
              onTap: () {
                // Navigate to CategoryPage when "Categories" is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllProductsPage()),
                );
              },
            ),
            // Add Order menu item
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle Logout action
              },
            ),
          ],
        ),
      ),

      // Body content for the ProductsPage
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'Search Products',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterProducts, // Filter products as the user types
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController, // Assign ScrollController
                      itemCount: filteredProducts.length,
                     itemBuilder: (context, index) {
  final product = filteredProducts[index];
  final productName = product['title'] ?? 'Unknown';
  final sellingPrice = product['selling_price']?.toString() ?? '0.00';
  final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0), // Reduced vertical space between products
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        final currentQuantity =
                            int.tryParse(controllers[productName]?.text ?? '0') ?? 0;
                        if (currentQuantity > 0) {
                          controllers[productName]?.text = (currentQuantity - 1).toString();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        final currentQuantity =
                            int.tryParse(controllers[productName]?.text ?? '0') ?? 0;
                        controllers[productName]?.text = (currentQuantity + 1).toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 30.0, // Adjust the height as needed
                child: TextField(
                  controller: controllers[productName],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center, // Horizontally center the text
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Qty',
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Vertically centering the text
                  ),
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
      ),
      const Divider(  // Divider between the products
        thickness: 1.0,  // Line thickness
        color: Colors.grey,  // Line color
      ),
    ],
  );
}

                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.teal[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Buy Now clicked')),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Buy Now'),
                        ),
                        ElevatedButton(
                          onPressed: _addToGlobalCart,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

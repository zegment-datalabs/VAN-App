import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:van_app_demo/cart_page.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/categorypage.dart';
import 'package:van_app_demo/myorders_page.dart';
import 'package:van_app_demo/login_page.dart';
import 'package:van_app_demo/myaccount.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  _AllProductsPageState createState() => _AllProductsPageState();
  
}

class _AllProductsPageState extends State<AllProductsPage> {
  Map<String, TextEditingController> controllers = {};
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
   String searchQuery = '';
  String _name = "User"; // Default name
  bool isLoading = true;
  int _selectedIndex = 0;
  String _profilePicUrl = "";

  

  // Search functionality
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  // ScrollController for smooth scrolling
  final ScrollController _scrollController = ScrollController();

  
   Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'User';
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
          products = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
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
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoryPage()),
        );
        break;
    
     case 2:
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CartPage()),
  );
  break;
   case 3:  // For All Products page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllProductsPage()),
        );
        break;
   case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyAccountPage()),
        );
        break;

      default:
        break;
    }
  }

  // Function to filter products based on search query
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
      final sellingPrice = double.tryParse(product['selling_price']?.toString() ?? '0.0') ?? 0.0;
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      total += sellingPrice * quantity;
    }

     return double.parse(total.toStringAsFixed(2)); // Ensure exactly 2 decimal places
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
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text('All products'),
      ),
      body: const Center(
        child: Text('All products page'),
      ),
=======
        title: const Text('All Products'),
        backgroundColor: const Color.fromARGB(255, 185, 92, 15),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart,color: Colors.black),
            onPressed: () {
              _resetQuantities();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          Builder(
            builder: (context) {
              return IconButton(
icon: const Icon(Icons.menu,color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
     endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 163, 94, 14)),
              child: Column(
                children: [
                  CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicUrl.isNotEmpty
                      ? NetworkImage(_profilePicUrl)
                      : null, // No image if URL is empty
                  child: _profilePicUrl.isEmpty
                      ? Icon(Icons.person, size: 30, color: Colors.white) // Placeholder icon
                      : null, // No icon if URL is available
                  backgroundColor: Colors.grey.shade400, // Background color for the icon
                ),
                  const SizedBox(height: 10.0),
                  Text(
                    _name, // Loaded name
                    style: const TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllProductsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('My Orders'),
              onTap: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyOrdersPage()),
            );

              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
                // Handle Logout action
              },
            ),
          ],
        ),
      ),
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
                    onChanged: _filterProducts,
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
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                                            setState(() {
                                              final currentQuantity =
                                                  int.tryParse(controllers[
                                                              productName]
                                                          ?.text ??
                                                      '0') ??
                                                      0;
                                              if (currentQuantity > 0) {
                                                controllers[productName]?.text =
                                                    (currentQuantity - 1)
                                                        .toString();
                                              }
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add,
                                              color: Colors.green),
                                          onPressed: () {
                                            setState(() {
                                              final currentQuantity =
                                                  int.tryParse(controllers[
                                                              productName]
                                                          ?.text ??
                                                      '0') ??
                                                      0;
                                              controllers[productName]?.text =
                                                  (currentQuantity + 1)
                                                      .toString();
                                            });
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
                                          contentPadding:
                                              EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                        ),
                                        style:
                                            const TextStyle(fontSize: 14.0),
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
                    color: Colors.teal[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                       ElevatedButton(
                            onPressed: () {
                              _addToGlobalCart();
                              _resetQuantities();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CartPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 201, 103, 23),
                              foregroundColor: Colors.black, // Set text color to black
                            ),
                            child: const Text('Buy Now'),
                          ),
                          ElevatedButton(
                            onPressed: _addToGlobalCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.black, // Set text color to black
                            ),
                            child: const Text('Add to Cart'),
                          ),

                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
=======
             bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [BoxShadow(color: Color.fromARGB(31, 24, 211, 55), blurRadius: 5.0)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromARGB(255, 12, 14, 13),
          unselectedItemColor: const Color.fromARGB(255, 7, 7, 7),
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.category),label: 'Category'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.view_list),label: 'All Products'),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: 'My Account'),
               // BottomNavigationBarItem(
            //   icon: Icon(Icons.assignment),
            //   label: 'Orders',
            // ),
          ],
        ),
             ),
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:van_app_demo/cart_page.dart';
import 'package:van_app_demo/homepage.dart'; // Import the HomePage
import 'package:van_app_demo/category/categorypage.dart'; // Import the CategoryPage
<<<<<<< Updated upstream
<<<<<<< HEAD
import 'package:van_app_demo/category/order_page.dart';
<<<<<<< HEAD
=======
import 'package:van_app_demo/category/allproducts.dart';
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
=======
import 'package:van_app_demo/myorders_page.dart';
import 'package:van_app_demo/category/allproducts.dart';
=======
import 'package:van_app_demo/myorders_page.dart';
import 'package:van_app_demo/category/allproducts.dart';
>>>>>>> Stashed changes
import 'package:van_app_demo/login_page.dart';
import 'package:van_app_demo/myaccount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
<<<<<<< Updated upstream
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
>>>>>>> Stashed changes

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
  bool isLoadingMore = false;
  String _name = "User";
<<<<<<< Updated upstream
   String _profilePicUrl = "";

  // Pagination variables
  int currentPage = 1;
  final int itemsPerPage = 8;
=======

  // Pagination variables
  int currentPage = 1;
  final int itemsPerPage = 10;
>>>>>>> Stashed changes

  // Search functionality
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  // ScrollController for smooth scrolling
  final ScrollController _scrollController = ScrollController();

  // Bottom Navigation Index
  int _selectedIndex = 0;

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'User';
<<<<<<< Updated upstream
       _profilePicUrl = prefs.getString('profilePicPath') ?? "";
=======
>>>>>>> Stashed changes
    });
  }

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
        filteredProducts = products.where((product) {
          final productName = product['title']?.toLowerCase() ?? '';
          return productName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }


  // Function to load more products
  void _loadMore() {
    setState(() {
      currentPage++;
    });

    // Simulate a delay for loading more data (e.g., fetching from Firestore)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoadingMore = false; // Stop loading spinner once new data is loaded
      });
    });
  }

  // Scroll listener to trigger loading more items when reaching the bottom
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoadingMore) {
        setState(() {
          isLoadingMore = true;
        });
        _loadMore();
      }
    }
  }


  // Function to programmatically scroll
  void _scrollToPosition(double offset,
      {Duration? duration, Curve curve = Curves.easeInOut}) {
    _scrollController.animateTo(
      offset,
      duration: duration ?? const Duration(milliseconds: 50), // Adjust duration for speed control
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

<<<<<<< Updated upstream
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Stashed changes
  Future<void> _addToGlobalCart() async {
    bool hasItemsToAdd = false;

    for (var product in filteredProducts) {
      final productName = product['title'] ?? 'Unknown';
      final sellingPrice =
          double.tryParse(product['selling_price']?.toString() ?? '0.00') ?? 0.0;
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      if (quantity > 0) {
<<<<<<< Updated upstream
        // Check if the product already exists in the global cart
=======
   Future<void> _addToGlobalCart() async {
=======
  Future<void> _addToGlobalCart() async {
    bool hasItemsToAdd = false;

>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
    for (var product in filteredProducts) {
      final productName = product['title'] ?? 'Unknown';
      final sellingPrice =
          double.tryParse(product['selling_price']?.toString() ?? '0.00') ?? 0.0;
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      if (quantity > 0) {
<<<<<<< HEAD
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
=======
        hasItemsToAdd = true; // There's at least one item to add

>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
        hasItemsToAdd = true; // There's at least one item to add

>>>>>>> Stashed changes
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

    if (hasItemsToAdd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products added to cart!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items to the cart before proceeding.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Calculate the total amount based on the filtered products and quantities
  double calculateTotalAmount() {
    double total = 0.0;

    for (var product in filteredProducts) {
      final productName = product['title'] ?? 'Unknown';
      final sellingPrice =
          double.tryParse(product['selling_price']?.toString() ?? '0.0') ?? 0.0;
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      total += sellingPrice * quantity;
    }

    return total;
  }

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
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AllProductsPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyAccountPage()),
        );
        break;
      default:
        break;
    }
  }

  // // Function to paginate
  // void _nextPage() {
  //   if ((currentPage * itemsPerPage) < filteredProducts.length) {
  //     setState(() {
  //       currentPage++;
  //     });
  //   }
  // }

  // void _previousPage() {
  //   if (currentPage > 1) {
  //     setState(() {
  //       currentPage--;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadUserData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    searchController.dispose();
    searchFocusNode.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Paginate the filtered products
    List<Map<String, dynamic>> currentPageProducts = filteredProducts
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: const Color.fromARGB(255, 185, 92, 15),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
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
<<<<<<< Updated upstream
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
=======
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Color.fromARGB(255, 182, 204, 209),
                    child: Icon(Icons.person, size: 40.0, color: Colors.teal),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    _name, // Loaded name
                    style: const TextStyle(color: Colors.black, fontSize: 20.0),
>>>>>>> Stashed changes
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () => _onItemTapped(2),
<<<<<<< Updated upstream
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('All Products'),
              onTap: () => _onItemTapped(3),
            ),
<<<<<<< HEAD
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
            // Add Order menu item
=======
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('All Products'),
              onTap: () => _onItemTapped(3),
            ),
>>>>>>> Stashed changes
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
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
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
<<<<<<< Updated upstream
<<<<<<< HEAD
                      controller: _scrollController, // Assign ScrollController
                      itemCount: filteredProducts.length,
<<<<<<< HEAD
=======
                      controller: _scrollController,
                      itemCount:
                          currentPageProducts.length + (isLoadingMore ? 1 : 0),
>>>>>>> Stashed changes
                      itemBuilder: (context, index) {
                        if (index == currentPageProducts.length) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                      final product = currentPageProducts[index];
                        final productImageUrl =
                            product['product_url']; // Image URL from Firestore
                        final productName = product['title'] ?? 'Unknown';
                        final sellingPrice =
                            product['selling_price']?.toString() ?? '0.00';
                        final quantity = int.tryParse(
                                controllers[productName]?.text ?? '0') ?? 0;
                      // itemCount: currentPageProducts.length,
                      // itemBuilder: (context, index) {
                      //   final product = currentPageProducts[index];
                      //   final productImageUrl =
                      //       product['product_url']; // Image URL from Firestore
                      //   final productName = product['title'] ?? 'Unknown';
                      //   final sellingPrice =
                      //       product['selling_price']?.toString() ?? '0.00';
                      //   final quantity = int.tryParse(
                      //           controllers[productName]?.text ?? '0') ?? 0;

                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  // Product Image
                                  Expanded(
                                    flex: 1,
                                    child: productImageUrl != null &&
                                            productImageUrl.isNotEmpty
                                        ? Image.network(
                                            productImageUrl,
                                            height: 50.0,
                                            width:
                                                70.0, // Adjust height of the image
                                            fit: BoxFit
                                                .cover, // Adjust image fit
                                          )
                                        : const Icon(Icons.image,
                                            size:
                                                70.0), // Placeholder if no image URL
                                  ),
                                  // Product Name and Price
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
                                          '₹ $sellingPrice',
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity Controls
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
                                                  int.tryParse(controllers[productName]?.text ?? '0') ?? 0;
                                              if (currentQuantity > 0) {
                                                controllers[productName]?.text = (currentQuantity - 1).toString();
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
                                                  int.tryParse(controllers[productName]?.text ?? '0') ?? 0;
                                              controllers[productName]?.text = (currentQuantity + 1).toString();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity Input
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 30.0,
                                      child: TextField(
                                        controller: controllers[productName],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Qty',
                                        ),
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
<<<<<<< Updated upstream
=======
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
=======
                      controller: _scrollController,
                      itemCount:
                          currentPageProducts.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == currentPageProducts.length) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
                        }
                      final product = currentPageProducts[index];
                        final productImageUrl =
                            product['product_url']; // Image URL from Firestore
                        final productName = product['title'] ?? 'Unknown';
                        final sellingPrice =
                            product['selling_price']?.toString() ?? '0.00';
                        final quantity = int.tryParse(
                                controllers[productName]?.text ?? '0') ?? 0;
                      // itemCount: currentPageProducts.length,
                      // itemBuilder: (context, index) {
                      //   final product = currentPageProducts[index];
                      //   final productImageUrl =
                      //       product['product_url']; // Image URL from Firestore
                      //   final productName = product['title'] ?? 'Unknown';
                      //   final sellingPrice =
                      //       product['selling_price']?.toString() ?? '0.00';
                      //   final quantity = int.tryParse(
                      //           controllers[productName]?.text ?? '0') ?? 0;

<<<<<<< HEAD
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
=======
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  // Product Image
                                  Expanded(
                                    flex: 1,
                                    child: productImageUrl != null &&
                                            productImageUrl.isNotEmpty
                                        ? Image.network(
                                            productImageUrl,
                                            height: 50.0,
                                            width:
                                                70.0, // Adjust height of the image
                                            fit: BoxFit
                                                .cover, // Adjust image fit
                                          )
                                        : const Icon(Icons.image,
                                            size:
                                                70.0), // Placeholder if no image URL
                                  ),
                                  // Product Name and Price
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
                                          '₹ $sellingPrice',
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity Controls
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
                                                  int.tryParse(controllers[productName]?.text ?? '0') ?? 0;
                                              if (currentQuantity > 0) {
                                                controllers[productName]?.text = (currentQuantity - 1).toString();
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
                                                  int.tryParse(controllers[productName]?.text ?? '0') ?? 0;
                                              controllers[productName]?.text = (currentQuantity + 1).toString();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity Input
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 30.0,
                                      child: TextField(
                                        controller: controllers[productName],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Qty',
                                        ),
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
>>>>>>> Stashed changes
                    ),
                  ),
                ),
                // // Pagination Controls
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.arrow_back_ios),
                //       onPressed: _previousPage,
                //     ),
                //     Text('Page $currentPage'),
                //     IconButton(
                //       icon: const Icon(Icons.arrow_forward_ios),
                //       onPressed: _nextPage,
                //     ),
                //   ],
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _addToGlobalCart();
                            _resetQuantities();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 212, 134, 17)),
                          child: const Text('Buy Now'),
                        ),
                        ElevatedButton(
                          onPressed: _addToGlobalCart,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(color: Color.fromARGB(31, 24, 211, 55), blurRadius: 5.0)
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromARGB(255, 12, 14, 13),
          unselectedItemColor: const Color.fromARGB(255, 7, 7, 7),
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.assignment),
            //   label: 'Orders',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              // All Products Item
              icon: Icon(Icons.view_list),
              label: 'All Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My Account',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:van_app_demo/cart_page.dart';
import 'package:van_app_demo/homepage.dart'; // Import the HomePage
import 'package:van_app_demo/category/categorypage.dart'; // Import the CategoryPage
import 'package:van_app_demo/category/allproducts.dart';
import 'package:van_app_demo/myaccount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:van_app_demo/widgets/common_widgets.dart';


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
  String _username = "User";
  String _profilePicUrl = "";
  // Pagination variables
  int currentPage = 1;
  final int itemsPerPage = 8;
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
      _username = prefs.getString('username') ?? 'User';
      _profilePicUrl = prefs.getString('profilePicPath') ?? "";
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
          products = snapshot.docs.map((doc) => doc.data()).toList();
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
      duration: duration ??
          const Duration(milliseconds: 50), // Adjust duration for speed control
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
    bool hasItemsToAdd = false;

    for (var product in filteredProducts) {
      final productName = product['title'] ?? 'Unknown';
      final sellingPrice =
          double.tryParse(product['selling_price']?.toString() ?? '0.00') ??
              0.0;
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      if (quantity > 0) {
        hasItemsToAdd = true; // There's at least one item to add

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
          MaterialPageRoute(builder: (context) => const MyAccountPage()),
        );
        break;
      default:
        break;
    }
  }

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
      appBar: CustomAppBar(
        title: widget.categoryTitle,
        onHomePressed: () => _onItemTapped(0),
        onCartPressed: () => _onItemTapped(2),
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
                CustomSearchBar(
                  controller: searchController,
                  onSearch: _filterProducts,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          currentPageProducts.length + (isLoadingMore ? 1 : 0),
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
                                controllers[productName]?.text ?? '0') ??
                            0;
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  // Product Image
                                  Expanded(
                                    flex: 1,
                                    child: productImageUrl != null &&
                                            productImageUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                5.0), // Makes it circular
                                            child: Image.network(
                                              productImageUrl,
                                              height:
                                                  50.0, // Increased for better circular shape
                                              width:
                                                  50.0, // Same width to maintain perfect circle
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 5.0, // Same as image radius
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            child: const Icon(Icons.image,
                                                size: 35.0,
                                                color: Colors.white),
                                          ),
                                  ),
                                  const SizedBox(width: 20),

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
                                  // Quantity Input
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
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

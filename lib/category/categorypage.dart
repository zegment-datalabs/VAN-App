import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/productspage.dart';
<<<<<<< Updated upstream
<<<<<<< HEAD
import 'package:van_app_demo/cart_page.dart'; // Import the CartPage
<<<<<<< HEAD
import 'allproducts.dart';
import 'order_page.dart'; // Add this import at the top if OrderPage is in another file

=======
=======
import 'package:van_app_demo/cart_page.dart';
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
import 'package:van_app_demo/cart_page.dart';
>>>>>>> Stashed changes
import 'package:van_app_demo/category/allproducts.dart';
import 'package:van_app_demo/myaccount.dart';
import 'package:van_app_demo/myorders_page.dart';
import 'package:van_app_demo/login_page.dart';

<<<<<<< Updated upstream
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
=======
>>>>>>> Stashed changes
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String searchQuery = '';
<<<<<<< Updated upstream
  String _name = "User"; // Default name
  List<Map<String, dynamic>> filteredProducts = [];
  Map<String, TextEditingController> controllers = {};
  int _selectedIndex = 0;
  String _profilePicUrl = "";
=======
  String _name = "User"; 
  List<Map<String, dynamic>> filteredProducts = [];
  Map<String, TextEditingController> controllers = {};
  int _selectedIndex = 0;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Attach listener to update search query
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

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

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: const Color.fromARGB(255, 185, 92, 15),
        automaticallyImplyLeading: false,
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
<<<<<<< Updated upstream
<<<<<<< HEAD
              leading: const Icon(Icons.category),
              title: const Text('All products'),
              onTap: () {
                // Navigate to CategoryPage when "Categories" is tapped
                Navigator.push(
                  context,
<<<<<<< HEAD
                  MaterialPageRoute(builder: (context) => const AllProducts()),
=======
                  MaterialPageRoute(builder: (context) => const AllProductsPage()),
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
                );
              },
=======
=======
>>>>>>> Stashed changes
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('All Products'),
              onTap: () => _onItemTapped(3),
<<<<<<< Updated upstream
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
>>>>>>> Stashed changes
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('category').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No categories available.',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                final categories = snapshot.data!.docs;
                final filteredCategories = categories.where((category) {
                  final categoryTitle = category['title']?.toLowerCase() ?? '';
                  return categoryTitle.contains(searchQuery.toLowerCase());
                }).toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index].data()
                        as Map<String, dynamic>;
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsPage(
                                categoryTitle: category['title'] ?? 'No Title',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          if (category['icon'] != null && category['icon'].isNotEmpty)
                            Image.network(
                              category['icon'],
                              height: 80.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 8.0),
                          Text(
                            category['title'] ?? 'No Title',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                        ),
                      ),
                    );
                  },
                );
              },
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

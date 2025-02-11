import 'package:flutter/material.dart';
import 'package:van_app_demo/category/allproducts.dart';
import 'package:van_app_demo/login_page.dart';
import 'category/confirmation_page.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/categorypage.dart'; 
import 'package:van_app_demo/myorders_page.dart';
import 'package:van_app_demo/myaccount.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

<<<<<<< Updated upstream
// Adjust the path as necessary
=======
>>>>>>> Stashed changes

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
  int _selectedIndex = 3; // Set the index to 3 for the CartPage
  String _name = "User";
  bool isLoading = true;
<<<<<<< Updated upstream
   String _profilePicUrl = "";
=======
>>>>>>> Stashed changes


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


  void initState() {
    super.initState();
<<<<<<< Updated upstream
<<<<<<< HEAD
<<<<<<< HEAD

=======
=======
      _loadUserData(); // Load username from SharedPreferences
    
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
      _loadUserData(); // Load username from SharedPreferences
    
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< HEAD
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
=======
  // Calculate the total price of all products in the cart with 2 decimal places
double calculateTotalAmount() {
  double totalAmount = Cart.selectedProducts.fold<double>(
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
  // Calculate the total price of all products in the cart with 2 decimal places
double calculateTotalAmount() {
  double totalAmount = Cart.selectedProducts.fold<double>(
>>>>>>> Stashed changes
    0.0,
    (total, product) {
      final quantity = (product['quantity'] as num?)?.toDouble() ?? 0.0; // Ensure double
      final sellingPrice = double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0;
      return total + (quantity * sellingPrice);
    },
  );
  return double.parse(totalAmount.toStringAsFixed(2)); // Ensure exactly 2 decimal places
}

// Calculate the total quantity of all products in the cart with 2 decimal places
String calculateTotalQuantity() {
  double totalQuantity = Cart.selectedProducts.fold<double>(
    0.0,
    (total, product) => total + ((product['quantity'] as num?)?.toDouble() ?? 0.0), // Ensure double
  );
  return totalQuantity.toStringAsFixed(2); // Ensure exactly 2 decimal places
}

<<<<<<< Updated upstream
<<<<<<< HEAD
  // Calculate the total quantity of all products in the cart
  int calculateTotalQuantity() {
    return Cart.selectedProducts.fold<int>(
      0,
      (total, product) => total + (product['quantity'] ?? 0) as int,
    );
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
=======
=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        title: const Text('Item Basket'),
=======
        title: const Text('Shopping Cart'),
>>>>>>> Stashed changes
        backgroundColor: const Color.fromARGB(255, 185, 92, 15),
        centerTitle: true,
        actions: [
          // Add the Search button (or keep it depending on your need)
          IconButton(
            icon: const Icon(Icons.search,color: Colors.black),
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
            icon: const Icon(Icons.add,color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllProductsPage()),
              );
            },
          ),
          // The Hamburger menu icon that opens the endDrawer
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu,color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Open the end drawer
              },
            ),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
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
        title: const Text('All Products'),
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
<<<<<<< Updated upstream
<<<<<<< HEAD
<<<<<<< HEAD
                                  // Displaying the selling price under quantity
=======
>>>>>>> Stashed changes
                                  Text(
                                    '₹ Price-${(double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
<<<<<<< Updated upstream
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
=======
                                  Text(
                                    '₹ Price-${(double.tryParse(product['sellingPrice']?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
>>>>>>> Stashed changes
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Decrement quantity or remove item
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
                                  // Increment quantity
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        product['quantity']++;
                                      });
                                    },
                                  ),
                                  // Remove item from cart
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 139, 28, 20),),
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
<<<<<<< Updated upstream
<<<<<<< HEAD
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
=======
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
          ElevatedButton(
            onPressed: Cart.selectedProducts.isEmpty
                ? null
                : () {
                    setState(() {
                      Cart.selectedProducts.clear();
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 139, 28, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
          // Place Order Button
          ElevatedButton(
            onPressed: Cart.selectedProducts.isEmpty
                ? null
                : () {
                    double orderValue = calculateTotalAmount();
                    List<Map<String, dynamic>> orderedProducts = List.from(Cart.selectedProducts);

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
>>>>>>> Stashed changes
                      ),
                    );
                  },
<<<<<<< Updated upstream
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
=======
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
=======
            style: ElevatedButton.styleFrom(
              backgroundColor: Cart.selectedProducts.isEmpty ? const Color.fromARGB(255, 209, 205, 205) : const Color.fromARGB(255, 199, 124, 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
>>>>>>> Stashed changes
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 24, 4, 4)),
            ),
          ),
        ],
      ),
    ],
  ),
),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(  // All Products Item
            icon: Icon(Icons.view_list),
            label: 'All Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Account',
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel Button - Clears the cart
          ElevatedButton(
            onPressed: Cart.selectedProducts.isEmpty
                ? null
                : () {
                    setState(() {
                      Cart.selectedProducts.clear();
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 139, 28, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
          // Place Order Button
          ElevatedButton(
            onPressed: Cart.selectedProducts.isEmpty
                ? null
                : () {
                    double orderValue = calculateTotalAmount();
                    List<Map<String, dynamic>> orderedProducts = List.from(Cart.selectedProducts);

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
            style: ElevatedButton.styleFrom(
              backgroundColor: Cart.selectedProducts.isEmpty ? const Color.fromARGB(255, 209, 205, 205) : const Color.fromARGB(255, 199, 124, 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 24, 4, 4)),
            ),
          ),
        ],
      ),
    ],
  ),
),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(  // All Products Item
            icon: Icon(Icons.view_list),
            label: 'All Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Account',
          ),
        ],
      ),
    );
  }
<<<<<<< Updated upstream
<<<<<<< HEAD
<<<<<<< HEAD
}
=======
}
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de
=======
}
>>>>>>> 29ec9781d997bf89ddc71afc1f59489122662828
=======
}
>>>>>>> Stashed changes

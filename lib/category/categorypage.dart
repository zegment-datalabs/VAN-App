import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/category/allproducts.dart';
import 'package:van_app_demo/category/productspage.dart';
import 'package:van_app_demo/cart_page.dart';
import 'package:van_app_demo/myaccount.dart';
import 'package:van_app_demo/widgets/common_widgets.dart';


class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String _username = "User";
  String _profilePicUrl = "";
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _profilePicUrl = prefs.getString('profilePicPath') ?? "";
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CartPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AllProductsPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyAccountPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      /// Use `CustomAppBar` instead of duplicating AppBar code
      appBar: CustomAppBar(
        title: "Categories",
        onHomePressed: () => _onItemTapped(0),
        onCartPressed: () => _onItemTapped(2),
      ),

      /// **Custom Drawer**
      endDrawer: CustomDrawer(
        profilePicUrl: _profilePicUrl,
        username: _username,
        onItemTapped: _onItemTapped,
      ),

      body: Column(
        children: [
          /// Use `CustomSearchBar` for search functionality
          CustomSearchBar(
            controller: searchController,
            onSearch: (query) {
              setState(() {
                searchQuery = query;
              });
            },
          ),
          Expanded(child: _buildCategoryGrid()),
        ],
      ),

      // Use `CustomBottomNavigationBar`
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
  Widget _buildCategoryGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('category').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No categories available.'));
        }

        final categories = snapshot.data!.docs;
        final filteredCategories = categories.where((category) {
          final categoryTitle = category['title']?.toLowerCase() ?? '';
          return categoryTitle.contains(searchQuery.toLowerCase());
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.85,
          ),
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index].data() as Map<String, dynamic>;
            return _buildCategoryCard(category);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 4.0,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductsPage(categoryTitle: category['title'] ?? 'No Title')),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category['icon'] != null && category['icon'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(category['icon'], height: 80, width: 80, fit: BoxFit.cover),
              ),
            const SizedBox(height: 8.0),
            Text(category['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  }

  


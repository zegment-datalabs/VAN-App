import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:van_app_demo/category/productspage.dart';
import 'package:van_app_demo/login_page.dart';
import 'package:van_app_demo/updationpage.dart';
import 'package:van_app_demo/category/categorypage.dart';
import 'package:van_app_demo/cart_page.dart';
import 'package:van_app_demo/category/allproducts.dart';
import 'package:van_app_demo/myaccount.dart';
import 'package:van_app_demo/myorders_page.dart';
import 'package:van_app_demo/widgets/common_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  String _profilePicUrl = "";
  String? userName;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load the saved user data from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('emailOrPhone') ?? 'Guest';
      _profilePicUrl = prefs.getString('profilePicPath') ?? "";
      userName = prefs.getString('username') ?? 'Guest';
    });

    print("✅ Loaded Username: userName");
    print("✅ Loaded Profile Pic URL: $_profilePicUrl");
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
      // case 2:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) =>  OrderPage(orderValue: 0, quantity: 0, selectedProducts: [])),
      //   );
      //   break;
      case 2:
        Navigator.push(
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

  // Function to logout
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Function to add category data to Firestore
  void _addCategoryData() async {
    final categoryCollection = db.collection("category");

    try {
      final categories = [
        {
          "category_id": 1001,
          "title": "Electronics",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1002,
          "title": "Clothing",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1003,
          "title": "Books",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1004,
          "title": "Shoes",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1005,
          "title": "Groceries",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1006,
          "title": "Toys",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1007,
          "title": "Beauty Products",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1008,
          "title": "Sports",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1009,
          "title": "Health",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1010,
          "title": "Appliances",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1011,
          "title": "Gaming",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1012,
          "title": "Food & Drink",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1013,
          "title": "Magazines",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1014,
          "title": "Stationery",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1015,
          "title": "Crafts",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1016,
          "title": "Adventure",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1017,
          "title": "Watches",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        },
        {
          "category_id": 1018,
          "title": "Gifts",
          "description": "hello",
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FOIP%20(5).jpg?alt=media&token=aaa2435a-0f2f-4b27-b1a8-d85129d2001d"
        }
      ];

      for (var category in categories) {
        await categoryCollection.doc(category['title'] as String).set(category);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category data successfully added!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding category data: $e')),
      );
    }
  }

  // Function to add product data to Firestore
  void _addProductData() async {
    final productCollection = db.collection("product");

    try {
      // Define the new product data
      final products = [
        {
          "product_id": "PRD0001",
          "product_url":
              "https://www.elgiganten.se/_next/image?url=https%3A%2F%2Fmedia.elkjop.com%2Fassets%2Fimage%2Fdv_web_D18000128914205&w=1200&q=75",
          "title": "Smartphone",
          "purchase_price": 8000,
          "selling_price": 10000,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-quality smartphone with 128GB storage.",
          "category": "Electronics",
          "MRP": 12000,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0002",
          "product_url":
              "https://th.bing.com/th/id/R.a243c72be94e93f1399f3399b06c7677?rik=hrhQ9%2b%2fJ1SSPHA&riu=http%3a%2f%2fwww.riskmanagementmonitor.com%2fwp-content%2fuploads%2f2014%2f12%2fLaptop1.jpg&ehk=OfidPRNnM1a1JERcjUs9J725LwV1tT7YdUTEmeAi5Gw%3d&risl=1&pid=ImgRaw&r=0",
          "title": "Laptop",
          "purchase_price": 40000,
          "selling_price": 45000,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A powerful laptop for work and gaming.",
          "category": "Electronics",
          "MRP": 50000,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0003",
          "product_url":
              "https://i5.walmartimages.com/asr/e1ae90b2-98da-443b-888c-a71228c5234e.eb10d07052b374f38aa17166043f5a7a.jpeg?odnWidth=1000&odnHeight=1000&odnBg=ffffff",
          "title": "Smart Watches",
          "purchase_price": 2200,
          "selling_price": 2000,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A feature-packed smartwatch with fitness tracking.",
          "category": "Electronics",
          "MRP": 3000,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0004",
          "product_url":
              "https://th.bing.com/th/id/R.b673d22704e1991f3aadecb0bd0144d1?rik=%2b44lBrgHsZ3bOQ&riu=http%3a%2f%2fpngimg.com%2fuploads%2ftablet%2ftablet_PNG8567.png&ehk=BdoUGf9HoFY42ZMRwrt9pj4hX%2f%2fBBwOhEPgJtN541tA%3d&risl=&pid=ImgRaw&r=0",
          "title": "Tablet",
          "purchase_price": 15000,
          "selling_price": 18000,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments":
              "A lightweight tablet with a sharp display and long battery life.",
          "category": "Electronics",
          "MRP": 20000,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0005",
          "product_url":
              "https://th.bing.com/th/id/OIP.VX1qaQUtfLP73Mg3C3GkhgHaHa?rs=1&pid=ImgDetMain",
          "title": "T-Shirt",
          "purchase_price": 250,
          "selling_price": 400,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Comfortable cotton t-shirt.",
          "category": "Clothing",
          "MRP": 500,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0006",
          "product_url":
              "https://img.freepik.com/premium-psd/isolated-folded-blue-jeans_34683-2556.jpg",
          "title": "Jeans",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Stylish denim jeans.",
          "category": "Clothing",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0007",
          "product_url":
              "https://th.bing.com/th/id/OIP.1MGjBAGlFG1-xYmaeEwFswHaJ3?w=186&h=248&c=7&r=0&o=5&pid=1.7",
          "title": "Jacket",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A stylish and warm jacket for winter.",
          "category": "Clothing",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0008",
          "product_url":
              "https://th.bing.com/th/id/OIP.bO4pS4CxtlOHb0LsEMiIWwHaIf?w=186&h=213&c=7&r=0&o=5&pid=1.7",
          "title": "Sweater",
          "purchase_price": 39.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A cozy sweater for chilly weather.",
          "category": "Clothing",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0009",
          "product_url":
              "https://th.bing.com/th/id/OIP.fFaX7nKq5_5gf2nSI3QEUgHaLK?w=186&h=280&c=7&r=0&o=5&pid=1.7",
          "title": "The Great Gatsby",
          "purchase_price": 9.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A classic novel by F. Scott Fitzgerald.",
          "category": "Books",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0010",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "1984",
          "purchase_price": 14.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A dystopian novel by George Orwell.",
          "category": "Books",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0011",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "War and Peace",
          "purchase_price": 12.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A historical Novel by Leo Tolstoy.",
          "category": "Books",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0012",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "The Catcher in the Rye",
          "purchase_price": 10.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A classic Novel by J.D. Salinger.",
          "category": "Books",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0013",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Running Shoes",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Comfortable shoes for running and sports.",
          "category": "Shoes",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0014",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Casual Sneakers",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Casual sneakers for everyday wear.",
          "category": "Shoes",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0015",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Leather Boots",
          "purchase_price": 129.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "High-quality leather boots for outdoor adventures.",
          "category": "Shoes",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0016",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Sandals",
          "purchase_price": 39.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Comfortable sandals for summer wear.",
          "category": "Shoes",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0017",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Organic Apples",
          "purchase_price": 3.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Fresh organic apples.",
          "category": "Groceries",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0018",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Milk",
          "purchase_price": 1.49,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Fresh milk from local farms.",
          "category": "Groceries",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0019",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Bananas",
          "purchase_price": 2.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Fresh and sweet bananas.",
          "category": "Groceries",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0020",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Eggs",
          "purchase_price": 3.49,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Farm-fresh eggs.",
          "category": "Groceries",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0021",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Lego Set",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A fun and creative Lego building set.",
          "category": "Toys",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0022",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Doll House",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A beautifully crafted doll house.",
          "category": "Toys",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0023",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "RC Car",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A fun remote-controlled car for kproduct_ids.",
          "category": "Toys",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0024",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Action Figure",
          "purchase_price": 29.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "An action figure of a popular superhero.",
          "category": "Toys",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0025",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Lipstick",
          "purchase_price": 15.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A vibrant red lipstick for all occasions.",
          "category": "Beauty Products",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0026",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Face Cream",
          "purchase_price": 29.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A nourishing face cream for dry skin.",
          "category": "Beauty Products",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0027",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Face Serum",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A rejuvenating face serum for glowing skin.",
          "category": "Beauty Products",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0028",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Shampoo",
          "purchase_price": 9.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A nourishing shampoo for healthy hair.",
          "category": "Beauty Products",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0029",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Basketball",
          "purchase_price": 24.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A durable and high-quality basketball.",
          "category": "Sports",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0030",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Soccer Ball",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A durable soccer ball for all levels of play.",
          "category": "Sports",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0031",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Baseball Glove",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-quality baseball glove for professional use.",
          "category": "Sports",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0032",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Tennis Racket",
          "purchase_price": 69.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A lightweight tennis racket for professional play.",
          "category": "Sports",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0033",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Herbal Tea",
          "purchase_price": 7.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A calming herbal tea for relaxation.",
          "category": "Health",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0034",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Protein Powder",
          "purchase_price": 29.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-quality protein powder for muscle recovery.",
          "category": "Health",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0035",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Vitamins",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A pack of essential vitamins for daily health.",
          "category": "Health",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0036",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Yoga Mat",
          "purchase_price": 25.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A comfortable mat for yoga and stretching.",
          "category": "Health",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0037",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Blender",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-powered blender for smoothies and more.",
          "category": "Appliances",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0038",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Vacuum Cleaner",
          "purchase_price": 99.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A powerful vacuum cleaner for your home.",
          "category": "Appliances",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0039",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Coffee Maker",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A stylish coffee maker for home brewing.",
          "category": "Appliances",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0040",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Air Fryer",
          "purchase_price": 99.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A modern air fryer for healthy cooking.",
          "category": "Appliances",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0041",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "PlayStation 5",
          "purchase_price": 499.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "The latest gaming console from Sony.",
          "category": "Gaming",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0042",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Gaming Mouse",
          "purchase_price": 39.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-performance gaming mouse.",
          "category": "Gaming",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0043",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Xbox Series X",
          "purchase_price": 499.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "The latest gaming console from Microsoft.",
          "category": "Gaming",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0044",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Gaming Headset",
          "purchase_price": 69.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-quality gaming headset with surround sound.",
          "category": "Gaming",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0045",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Pizza",
          "purchase_price": 12.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "image": "assets/images/food_drink/pizza.jpg",
          "comments": "Delicious pizza with your choice of toppings.",
          "category": "Food & Drink",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0046",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Soft Drink",
          "purchase_price": 1.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Refreshing soda to complement your meal.",
          "category": "Food & Drink",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0047",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Pasta",
          "purchase_price": 4.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Delicious pasta with your choice of sauce.",
          "category": "Food & Drink",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0048",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Juice",
          "purchase_price": 2.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Freshly squeezed juice made with real fruit.",
          "category": "Food & Drink",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0049",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "National Geographic",
          "purchase_price": 5.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A popular magazine on nature and science.",
          "category": "Magazines",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0050",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Time Magazine",
          "purchase_price": 4.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A leading news magazine covering global events.",
          "category": "Magazines",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0051",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Scientific American",
          "purchase_price": 6.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A magazine focused on scientific discovery.",
          "category": "Magazines",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0052",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "The Economist",
          "purchase_price": 7.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A weekly magazine that covers global issues.",
          "category": "Magazines",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0053",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Notebook",
          "purchase_price": 3.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-quality notebook for work or school.",
          "category": "Stationery",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0054",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Pens",
          "purchase_price": 2.49,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A set of smooth-writing pens.",
          "category": "Stationery",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0055",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Eraser",
          "purchase_price": 1.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A high-quality eraser for smooth corrections.",
          "category": "Stationery",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0056",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Ruler",
          "purchase_price": 2.49,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A sturdy ruler for measurements.",
          "category": "Stationery",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0057",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Painting Kit",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A complete painting kit with brushes and paints.",
          "category": "Crafts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0058",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Knitting Set",
          "purchase_price": 14.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A knitting set with yarn and needles.",
          "category": "Crafts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0059",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Sculpting Clay",
          "purchase_price": 14.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A set of sculpting clay for art projects.",
          "category": "Crafts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0060",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Origami Paper",
          "purchase_price": 6.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "High-quality paper for origami folding.",
          "category": "Crafts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0061",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Camping Tent",
          "purchase_price": 99.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A durable tent for your next camping trip.",
          "category": "Adventure",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0062",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Backpack",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A spacious and comfortable backpack for hiking.",
          "category": "Adventure",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0063",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Sleeping Bag",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A comfortable sleeping bag for camping trips.",
          "category": "Adventure",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0064",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Hiking Boots",
          "purchase_price": 89.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "Durable hiking boots for all terrains.",
          "category": "Adventure",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0065",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Analog Watch",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A stylish analog watch with a leather strap.",
          "category": "Watches",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0066",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Smart Watch",
          "purchase_price": 149.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A smart watch with health tracking features.",
          "category": "Watches",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0067",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Luxury Watch",
          "purchase_price": 799.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A stylish luxury watch with a stainless steel band.",
          "category": "Watches",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0068",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Digital Watch",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A sleek digital watch with multiple functions.",
          "category": "Watches",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0069",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Gift Card",
          "purchase_price": 25.00,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A versatile gift card for any occasion.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0070",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Gift Basket",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A beautifully arranged gift basket with treats.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0071",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Luxury Perfume",
          "purchase_price": 50.00,
          "selling_price": 199.99,
          "opening_stock": 15,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A premium fragrance for a luxurious experience.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0072",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Personalized Mug",
          "purchase_price": 10.00,
          "selling_price": 29.99,
          "opening_stock": 20,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A customizable mug perfect for gifting.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0073",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Candles Set",
          "purchase_price": 25.00,
          "selling_price": 59.99,
          "opening_stock": 12,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A set of soothing scented candles.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0074",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Chocolate Box",
          "purchase_price": 15.00,
          "selling_price": 49.99,
          "opening_stock": 25,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "An assorted collection of fine chocolates.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0075",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Fleece Blanket",
          "purchase_price": 18.00,
          "selling_price": 39.99,
          "opening_stock": 30,
          "uom": "No",
          "reorder_level": 7,
          "location": "Warehouse",
          "comments": "A cozy fleece blanket for any occasion.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0076",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Spa Set",
          "purchase_price": 35.00,
          "selling_price": 79.99,
          "opening_stock": 18,
          "uom": "No",
          "reorder_level": 4,
          "location": "Warehouse",
          "comments": "A relaxing spa set for ultimate self-care.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0077",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Wine Glass Set",
          "purchase_price": 20.00,
          "selling_price": 49.99,
          "opening_stock": 22,
          "uom": "No",
          "reorder_level": 4,
          "location": "Warehouse",
          "comments": "A set of elegant wine glasses for special occasions.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0078",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Photo Frame",
          "purchase_price": 12.00,
          "selling_price": 24.99,
          "opening_stock": 28,
          "uom": "No",
          "reorder_level": 6,
          "location": "Warehouse",
          "comments": "A classic photo frame to hold cherished memories.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0079",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Jewelry Box",
          "purchase_price": 30.00,
          "selling_price": 69.99,
          "opening_stock": 14,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A beautifully crafted jewelry box for your treasures.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0080",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Tea Set",
          "purchase_price": 40.00,
          "selling_price": 99.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A delicate tea set for a soothing experience.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0081",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Travel Set",
          "purchase_price": 15.00,
          "selling_price": 39.99,
          "opening_stock": 25,
          "uom": "No",
          "reorder_level": 6,
          "location": "Warehouse",
          "comments": "A compact travel set for the modern traveler.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0082",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Portable Speaker",
          "purchase_price": 35.00,
          "selling_price": 89.99,
          "opening_stock": 20,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A high-quality portable speaker for on-the-go music.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0083",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Smartwatch",
          "purchase_price": 100.00,
          "selling_price": 249.99,
          "opening_stock": 12,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments": "A stylish smartwatch for the modern individual.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0084",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Luxury Wallet",
          "purchase_price": 70.00,
          "selling_price": 149.99,
          "opening_stock": 18,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A sophisticated leather wallet for everyday use.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0085",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Custom Jewelry",
          "purchase_price": 50.00,
          "selling_price": 129.99,
          "opening_stock": 14,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments":
              "A personalized piece of jewelry for that special someone.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0086",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Bluetooth Earbuds",
          "purchase_price": 25.00,
          "selling_price": 59.99,
          "opening_stock": 20,
          "uom": "No",
          "reorder_level": 4,
          "location": "Warehouse",
          "comments": "Wireless earbuds with great sound quality.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0087",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Cozy Slippers",
          "purchase_price": 18.00,
          "selling_price": 39.99,
          "opening_stock": 22,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "Soft, cozy slippers for indoor relaxation.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0088",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Wine Cooler",
          "purchase_price": 40.00,
          "selling_price": 89.99,
          "opening_stock": 10,
          "uom": "No",
          "reorder_level": 10,
          "location": "Warehouse",
          "comments":
              "A stylish cooler to keep your wine at the perfect temperature.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0089",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Outdoor Picnic Set",
          "purchase_price": 60.00,
          "selling_price": 149.99,
          "opening_stock": 15,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "Everything you need for the perfect outdoor picnic.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        },
        {
          "product_id": "PRD0090",
          "product_url":
              "https://firebasestorage.googleapis.com/v0/b/zegmentdata.appspot.com/o/products%2FScreenshot%202023-06-30%20213751.png?alt=media&token=cd3c6956-c557-4088-908a-819e8245685a",
          "title": "Leather Journal",
          "purchase_price": 25.00,
          "selling_price": 59.99,
          "opening_stock": 30,
          "uom": "No",
          "reorder_level": 7,
          "location": "Warehouse",
          "comments":
              "A premium leather journal for personal thoughts or work.",
          "category": "Gifts",
          "MRP": 90,
          "supplier_name": "Rahul",
          "TAX": 7.5,
          "maximum_stock": 100,
          "minimum_stock": 5,
        }
      ];

      for (var product in products) {
        await productCollection.doc(product['title'] as String).set(product);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('product data successfully added!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product data: $e')),
      );
    }
  }

  // Function to load categories from Firestore
  void _loadCategories() async {
    final categoryCollection = db.collection("category");

    try {
      final snapshot = await categoryCollection.get();

      for (var doc in snapshot.docs) {
        final categoryData = doc.data();
        final title = categoryData['title'];
        final iconString = categoryData['icon']; // icon is a String

        // Safely cast the icon to String and map it
        if (iconString is String) {
          final icon = getCategoryIcon(iconString); // Map string to actual Icon
          print('Category: $title, Icon: $icon');
        }
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Helper function to map string icon names to actual Icons
  IconData getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'restaurant':
        return Icons.restaurant;
      case 'sports':
        return Icons.sports;
      case 'local_florist':
        return Icons.local_florist;
      case 'electronics':
        return Icons.devices;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: _profilePicUrl.isNotEmpty
                      ? NetworkImage(_profilePicUrl)
                      : null,
                  backgroundColor: Colors.grey.shade400,
                  child: _profilePicUrl.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 10),
                Text("Welcome, ${userName ?? 'loading'}!",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // Grid Menu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildGridButton(
                      Icons.category, 'Add Category', _addCategoryData),
                  _buildGridButton(
                      Icons.add_shopping_cart, "Add Product", _addProductData),
                  _buildGridButton(Icons.update, "Order Management", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdationPage()));
                  }),
                  _buildGridButton(Icons.view_list, "View Products", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllProductsPage()));
                  }),
                  _buildGridButton(Icons.shopping_cart, "My Orders", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOrdersPage()));
                  }),
                  _buildGridButton(Icons.logout, "Logout", _logout),
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

  Widget _buildGridButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal, width: 2), // Added border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.teal),
            const SizedBox(height: 12),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

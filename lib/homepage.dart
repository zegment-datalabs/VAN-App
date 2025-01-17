import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  String? profilePicPath;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load the saved user data from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('emailPhone') ?? 'Guest';
      profilePicPath =
          prefs.getString('profilePicPath') ?? 'default-avatar-url';
    });
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
        {"title": "Electronics", "icon": "electrical_services"},
        {"title": "Clothing", "icon": "shopping_bag"},
        {"title": "Books", "icon": "book"},
        {"title": "Shoes", "icon": "run_circle"},
        {"title": "Groceries", "icon": "local_grocery_store"},
        {'title': 'Toys', 'icon': "toys"},
        {'title': 'Beauty Products', 'icon': "brush"},
        {'title': 'Sports', 'icon': "sports"},
        {'title': 'Health', 'icon': "health_and_safety"},
        {'title': 'Home Appliances', 'icon': "kitchen"},
        {'title': 'Gaming', 'icon': "videogame_asset"},
        {'title': 'Food & Drink', 'icon': "fastfood"},
        {'title': 'Books & Magazines', 'icon': "bookmark"},
        {'title': 'Stationery', 'icon': "create"},
        {'title': 'Crafts', 'icon': "palette"},
        {'title': 'Outdoor & Adventure', 'icon': "outdoor_grill"},
        {'title': 'Watches', 'icon': "watch"},
        {'title': 'Gifts', 'icon': "card_giftcard"},
      ];

      for (var category in categories) {
        await categoryCollection.doc(category["title"]).set(category);
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
          "product_url": "URL",
          "title": "Smartphone",
          "purchase_price": 699.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-quality smartphone with 128GB storage.",
          "category": "Electronics"
        },
        {
          "product_id": "PRD0002",
          "product_url": "URL",
          "title": "Laptop",
          "purchase_price": 999.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A powerful laptop for work and gaming.",
          "category": "Electronics"
        },
        {
          "product_id": "PRD0003",
          "product_url": "URL",
          "title": "Smart Watch",
          "purchase_price": 199.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A feature-packed smartwatch with fitness tracking.",
          "category": "Electronics"
        },
        {
          "product_id": "PRD0004",
          "product_url": "URL",
          "title": "Tablet",
          "purchase_price": 399.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments":
              "A lightweight tablet with a sharp display and long battery life.",
          "category": "Electronics"
        },
        {
          "product_id": "PRD0005",
          "product_url": "URL",
          "title": "T-Shirt",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Comfortable cotton t-shirt.",
          "category": "Clothing"
        },
        {
          "product_id": "PRD0006",
          "product_url": "URL",
          "title": "Jeans",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Stylish denim jeans.",
          "category": "Clothing"
        },
        {
          "product_id": "PRD0007",
          "product_url": "URL",
          "title": "Jacket",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A stylish and warm jacket for winter.",
          "category": "Clothing"
        },
        {
          "product_id": "PRD0008",
          "product_url": "URL",
          "title": "Sweater",
          "purchase_price": 39.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A cozy sweater for chilly weather.",
          "category": "Clothing"
        },
        {
          "product_id": "PRD0009",
          "product_url": "URL",
          "title": "The Great Gatsby",
          "purchase_price": 9.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A classic novel by F. Scott Fitzgerald.",
          "category": "Books"
        },
        {
          "product_id": "PRD0010",
          "product_url": "URL",
          "title": "1984",
          "purchase_price": 14.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A dystopian novel by George Orwell.",
          "category": "Books"
        },
        {
          "product_id": "PRD0011",
          "product_url": "URL",
          "title": "War and Peace",
          "purchase_price": 12.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A historical Novel by Leo Tolstoy.",
          "category": "Books"
        },
        {
          "product_id": "PRD0012",
          "product_url": "URL",
          "title": "The Catcher in the Rye",
          "purchase_price": 10.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A classic Novel by J.D. Salinger.",
          "category": "Books"
        },
        {
          "product_id": "PRD0013",
          "product_url": "URL",
          "title": "Running Shoes",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Comfortable shoes for running and sports.",
          "category": "Shoes"
        },
        {
          "product_id": "PRD0014",
          "product_url": "URL",
          "title": "Casual Sneakers",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Casual sneakers for everyday wear.",
          "category": "Shoes"
        },
        {
          "product_id": "PRD0015",
          "product_url": "URL",
          "title": "Leather Boots",
          "purchase_price": 129.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "High-quality leather boots for outdoor adventures.",
          "category": "Shoes"
        },
        {
          "product_id": "PRD0016",
          "product_url": "URL",
          "title": "Sandals",
          "purchase_price": 39.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Comfortable sandals for summer wear.",
          "category": "Shoes"
        },
        {
          "product_id": "PRD0017",
          "product_url": "URL",
          "title": "Organic Apples",
          "purchase_price": 3.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Fresh organic apples.",
          "category": "Groceries"
        },
        {
          "product_id": "PRD0018",
          "product_url": "URL",
          "title": "Milk",
          "purchase_price": 1.49,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Fresh milk from local farms.",
          "category": "Groceries"
        },
        {
          "product_id": "PRD0019",
          "product_url": "URL",
          "title": "Bananas",
          "purchase_price": 2.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Fresh and sweet bananas.",
          "category": "Groceries"
        },
        {
          "product_id": "PRD0020",
          "product_url": "URL",
          "title": "Eggs",
          "purchase_price": 3.49,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Farm-fresh eggs.",
          "category": "Groceries"
        },
        {
          "product_id": "PRD0021",
          "product_url": "URL",
          "title": "Lego Set",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A fun and creative Lego building set.",
          "category": "Toys"
        },
        {
          "product_id": "PRD0022",
          "product_url": "URL",
          "title": "Doll House",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A beautifully crafted doll house.",
          "category": "Toys"
        },
        {
          "product_id": "PRD0023",
          "product_url": "URL",
          "title": "RC Car",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A fun remote-controlled car for kproduct_ids.",
          "category": "Toys"
        },
        {
          "product_id": "PRD0024",
          "product_url": "URL",
          "title": "Action Figure",
          "purchase_price": 29.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "An action figure of a popular superhero.",
          "category": "Toys"
        },
        {
          "product_id": "PRD0025",
          "product_url": "URL",
          "title": "Lipstick",
          "purchase_price": 15.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A vibrant red lipstick for all occasions.",
          "category": "Beauty Products"
        },
        {
          "product_id": "PRD0026",
          "product_url": "URL",
          "title": "Face Cream",
          "purchase_price": 29.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A nourishing face cream for dry skin.",
          "category": "Beauty Products"
        },
        {
          "product_id": "PRD0027",
          "product_url": "URL",
          "title": "Face Serum",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A rejuvenating face serum for glowing skin.",
          "category": "Beauty Products"
        },
        {
          "product_id": "PRD0028",
          "product_url": "URL",
          "title": "Shampoo",
          "purchase_price": 9.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A nourishing shampoo for healthy hair.",
          "category": "Beauty Products"
        },
        {
          "product_id": "PRD0029",
          "product_url": "URL",
          "title": "Basketball",
          "purchase_price": 24.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A durable and high-quality basketball.",
          "category": "Sports"
        },
        {
          "product_id": "PRD0030",
          "product_url": "URL",
          "title": "Soccer Ball",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A durable soccer ball for all levels of play.",
          "category": "Sports"
        },
        {
          "product_id": "PRD0031",
          "product_url": "URL",
          "title": "Baseball Glove",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-quality baseball glove for professional use.",
          "category": "Sports"
        },
        {
          "product_id": "PRD0032",
          "product_url": "URL",
          "title": "Tennis Racket",
          "purchase_price": 69.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A lightweight tennis racket for professional play.",
          "category": "Sports"
        },
        {
          "product_id": "PRD0033",
          "product_url": "URL",
          "title": "Herbal Tea",
          "purchase_price": 7.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A calming herbal tea for relaxation.",
          "category": "Health"
        },
        {
          "product_id": "PRD0034",
          "product_url": "URL",
          "title": "Protein Powder",
          "purchase_price": 29.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-quality protein powder for muscle recovery.",
          "category": "Health"
        },
        {
          "product_id": "PRD0035",
          "product_url": "URL",
          "title": "Vitamins",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A pack of essential vitamins for daily health.",
          "category": "Health"
        },
        {
          "product_id": "PRD0036",
          "product_url": "URL",
          "title": "Yoga Mat",
          "purchase_price": 25.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A comfortable mat for yoga and stretching.",
          "category": "Health"
        },
        {
          "product_id": "PRD0037",
          "product_url": "URL",
          "title": "Blender",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-powered blender for smoothies and more.",
          "category": "Home Appliances"
        },
        {
          "product_id": "PRD0038",
          "product_url": "URL",
          "title": "Vacuum Cleaner",
          "purchase_price": 99.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A powerful vacuum cleaner for your home.",
          "category": "Home Appliances"
        },
        {
          "product_id": "PRD0039",
          "product_url": "URL",
          "title": "Coffee Maker",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A stylish coffee maker for home brewing.",
          "category": "Home Appliances"
        },
        {
          "product_id": "PRD0040",
          "product_url": "URL",
          "title": "Air Fryer",
          "purchase_price": 99.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A modern air fryer for healthy cooking.",
          "category": "Home Appliances"
        },
        {
          "product_id": "PRD0041",
          "product_url": "URL",
          "title": "PlayStation 5",
          "purchase_price": 499.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "The latest gaming console from Sony.",
          "category": "Gaming"
        },
        {
          "product_id": "PRD0042",
          "product_url": "URL",
          "title": "Gaming Mouse",
          "purchase_price": 39.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-performance gaming mouse.",
          "category": "Gaming"
        },
        {
          "product_id": "PRD0043",
          "product_url": "URL",
          "title": "Xbox Series X",
          "purchase_price": 499.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "The latest gaming console from Microsoft.",
          "category": "Gaming"
        },
        {
          "product_id": "PRD0044",
          "product_url": "URL",
          "title": "Gaming Headset",
          "purchase_price": 69.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-quality gaming headset with surround sound.",
          "category": "Gaming"
        },
        {
          "product_id": "PRD0045",
          "product_url": "URL",
          "title": "Pizza",
          "purchase_price": 12.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "image": "assets/images/food_drink/pizza.jpg",
          "comments": "Delicious pizza with your choice of toppings.",
          "category": "Food & Drink"
        },
        {
          "product_id": "PRD0046",
          "product_url": "URL",
          "title": "Soft Drink",
          "purchase_price": 1.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Refreshing soda to complement your meal.",
          "category": "Food & Drink"
        },
        {
          "product_id": "PRD0047",
          "product_url": "URL",
          "title": "Pasta",
          "purchase_price": 4.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Delicious pasta with your choice of sauce.",
          "category": "Food & Drink"
        },
        {
          "product_id": "PRD0048",
          "product_url": "URL",
          "title": "Juice",
          "purchase_price": 2.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Freshly squeezed juice made with real fruit.",
          "category": "Food & Drink"
        },
        {
          "product_id": "PRD0049",
          "product_url": "URL",
          "title": "National Geographic",
          "purchase_price": 5.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A popular magazine on nature and science.",
          "category": "Books & Magazines"
        },
        {
          "product_id": "PRD0050",
          "product_url": "URL",
          "title": "Time Magazine",
          "purchase_price": 4.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A leading news magazine covering global events.",
          "category": "Books & Magazines"
        },
        {
          "product_id": "PRD0051",
          "product_url": "URL",
          "title": "Scientific American",
          "purchase_price": 6.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A magazine focused on scientific discovery.",
          "category": "Books & Magazines"
        },
        {
          "product_id": "PRD0052",
          "product_url": "URL",
          "title": "The Economist",
          "purchase_price": 7.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A weekly magazine that covers global issues.",
          "category": "Books & Magazines"
        },
        {
          "product_id": "PRD0053",
          "product_url": "URL",
          "title": "Notebook",
          "purchase_price": 3.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-quality notebook for work or school.",
          "category": "Stationery"
        },
        {
          "product_id": "PRD0054",
          "product_url": "URL",
          "title": "Pens",
          "purchase_price": 2.49,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A set of smooth-writing pens.",
          "category": "Stationery"
        },
        {
          "product_id": "PRD0055",
          "product_url": "URL",
          "title": "Eraser",
          "purchase_price": 1.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A high-quality eraser for smooth corrections.",
          "category": "Stationery"
        },
        {
          "product_id": "PRD0056",
          "product_url": "URL",
          "title": "Ruler",
          "purchase_price": 2.49,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A sturdy ruler for measurements.",
          "category": "Stationery"
        },
        {
          "product_id": "PRD0057",
          "product_url": "URL",
          "title": "Painting Kit",
          "purchase_price": 19.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A complete painting kit with brushes and paints.",
          "category": "Crafts"
        },
        {
          "product_id": "PRD0058",
          "product_url": "URL",
          "title": "Knitting Set",
          "purchase_price": 14.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A knitting set with yarn and needles.",
          "category": "Crafts"
        },
        {
          "product_id": "PRD0059",
          "product_url": "URL",
          "title": "Sculpting Clay",
          "purchase_price": 14.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A set of sculpting clay for art projects.",
          "category": "Crafts"
        },
        {
          "product_id": "PRD0060",
          "product_url": "URL",
          "title": "Origami Paper",
          "purchase_price": 6.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "High-quality paper for origami folding.",
          "category": "Crafts"
        },
        {
          "product_id": "PRD0061",
          "product_url": "URL",
          "title": "Camping Tent",
          "purchase_price": 99.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A durable tent for your next camping trip.",
          "category": "Outdoor & Adventure"
        },
        {
          "product_id": "PRD0062",
          "product_url": "URL",
          "title": "Backpack",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A spacious and comfortable backpack for hiking.",
          "category": "Outdoor & Adventure"
        },
        {
          "product_id": "PRD0063",
          "product_url": "URL",
          "title": "Sleeping Bag",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A comfortable sleeping bag for camping trips.",
          "category": "Outdoor & Adventure"
        },
        {
          "product_id": "PRD0064",
          "product_url": "URL",
          "title": "Hiking Boots",
          "purchase_price": 89.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "Durable hiking boots for all terrains.",
          "category": "Outdoor & Adventure"
        },
        {
          "product_id": "PRD0065",
          "product_url": "URL",
          "title": "Analog Watch",
          "purchase_price": 79.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A stylish analog watch with a leather strap.",
          "category": "Watches"
        },
        {
          "product_id": "PRD0066",
          "product_url": "URL",
          "title": "Smart Watch",
          "purchase_price": 149.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A smart watch with health tracking features.",
          "category": "Watches"
        },
        {
          "product_id": "PRD0067",
          "product_url": "URL",
          "title": "Luxury Watch",
          "purchase_price": 799.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A stylish luxury watch with a stainless steel band.",
          "category": "Watches"
        },
        {
          "product_id": "PRD0068",
          "product_url": "URL",
          "title": "Digital Watch",
          "purchase_price": 49.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A sleek digital watch with multiple functions.",
          "category": "Watches"
        },
        {
          "product_id": "PRD0069",
          "product_url": "URL",
          "title": "Gift Card",
          "purchase_price": 25.00,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A versatile gift card for any occasion.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0070",
          "product_url": "URL",
          "title": "Gift Basket",
          "purchase_price": 59.99,
          "selling_price": 699.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A beautifully arranged gift basket with treats.",
          "category": "Gifts"
        },
        
        {
          "product_id": "PRD0071",
          "product_url": "URL",
          "title": "Luxury Perfume",
          "purchase_price": 50.00,
          "selling_price": 199.99,
          "qty": 15,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A premium fragrance for a luxurious experience.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0072",
          "product_url": "URL",
          "title": "Personalized Mug",
          "purchase_price": 10.00,
          "selling_price": 29.99,
          "qty": 20,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A customizable mug perfect for gifting.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0073",
          "product_url": "URL",
          "title": "Candles Set",
          "purchase_price": 25.00,
          "selling_price": 59.99,
          "qty": 12,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A set of soothing scented candles.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0074",
          "product_url": "URL",
          "title": "Chocolate Box",
          "purchase_price": 15.00,
          "selling_price": 49.99,
          "qty": 25,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "An assorted collection of fine chocolates.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0075",
          "product_url": "URL",
          "title": "Fleece Blanket",
          "purchase_price": 18.00,
          "selling_price": 39.99,
          "qty": 30,
          "uom": "No",
          "reorder_level": 7,
          "location": "Warehouse",
          "comments": "A cozy fleece blanket for any occasion.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0076",
          "product_url": "URL",
          "title": "Spa Set",
          "purchase_price": 35.00,
          "selling_price": 79.99,
          "qty": 18,
          "uom": "No",
          "reorder_level": 4,
          "location": "Warehouse",
          "comments": "A relaxing spa set for ultimate self-care.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0077",
          "product_url": "URL",
          "title": "Wine Glass Set",
          "purchase_price": 20.00,
          "selling_price": 49.99,
          "qty": 22,
          "uom": "No",
          "reorder_level": 4,
          "location": "Warehouse",
          "comments": "A set of elegant wine glasses for special occasions.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0078",
          "product_url": "URL",
          "title": "Photo Frame",
          "purchase_price": 12.00,
          "selling_price": 24.99,
          "qty": 28,
          "uom": "No",
          "reorder_level": 6,
          "location": "Warehouse",
          "comments": "A classic photo frame to hold cherished memories.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0079",
          "product_url": "URL",
          "title": "Jewelry Box",
          "purchase_price": 30.00,
          "selling_price": 69.99,
          "qty": 14,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A beautifully crafted jewelry box for your treasures.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0080",
          "product_url": "URL",
          "title": "Tea Set",
          "purchase_price": 40.00,
          "selling_price": 99.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A delicate tea set for a soothing experience.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0081",
          "product_url": "URL",
          "title": "Travel Set",
          "purchase_price": 15.00,
          "selling_price": 39.99,
          "qty": 25,
          "uom": "No",
          "reorder_level": 6,
          "location": "Warehouse",
          "comments": "A compact travel set for the modern traveler.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0082",
          "product_url": "URL",
          "title": "Portable Speaker",
          "purchase_price": 35.00,
          "selling_price": 89.99,
          "qty": 20,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A high-quality portable speaker for on-the-go music.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0083",
          "product_url": "URL",
          "title": "Smartwatch",
          "purchase_price": 100.00,
          "selling_price": 249.99,
          "qty": 12,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A stylish smartwatch for the modern individual.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0084",
          "product_url": "URL",
          "title": "Luxury Wallet",
          "purchase_price": 70.00,
          "selling_price": 149.99,
          "qty": 18,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "A sophisticated leather wallet for everyday use.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0085",
          "product_url": "URL",
          "title": "Custom Jewelry",
          "purchase_price": 50.00,
          "selling_price": 129.99,
          "qty": 14,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A personalized piece of jewelry for that special someone.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0086",
          "product_url": "URL",
          "title": "Bluetooth Earbuds",
          "purchase_price": 25.00,
          "selling_price": 59.99,
          "qty": 20,
          "uom": "No",
          "reorder_level": 4,
          "location": "Warehouse",
          "comments": "Wireless earbuds with great sound quality.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0087",
          "product_url": "URL",
          "title": "Cozy Slippers",
          "purchase_price": 18.00,
          "selling_price": 39.99,
          "qty": 22,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "Soft, cozy slippers for indoor relaxation.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0088",
          "product_url": "URL",
          "title": "Wine Cooler",
          "purchase_price": 40.00,
          "selling_price": 89.99,
          "qty": 10,
          "uom": "No",
          "reorder_level": 3,
          "location": "Warehouse",
          "comments": "A stylish cooler to keep your wine at the perfect temperature.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0089",
          "product_url": "URL",
          "title": "Outdoor Picnic Set",
          "purchase_price": 60.00,
          "selling_price": 149.99,
          "qty": 15,
          "uom": "No",
          "reorder_level": 5,
          "location": "Warehouse",
          "comments": "Everything you need for the perfect outdoor picnic.",
          "category": "Gifts"
        },
        {
          "product_id": "PRD0090",
          "product_url": "URL",
          "title": "Leather Journal",
          "purchase_price": 25.00,
          "selling_price": 59.99,
          "qty": 30,
          "uom": "No",
          "reorder_level": 7,
          "location": "Warehouse",
          "comments": "A premium leather journal for personal thoughts or work.",
          "category": "Gifts"
        }
      ];

      // Check for each product if it already exists in the database by its title
      for (var product in products) {
        final existingProductQuery = await productCollection
            .where('title', isEqualTo: product['title'])
            .get();

        if (existingProductQuery.docs.isEmpty) {
          // If no existing product is found, add the product to the Firestore collection
          await productCollection.add(product);
        } else {
          // If the product exists, you can update it (e.g., updating price or description)
          var existingProduct = existingProductQuery.docs.first;
          await productCollection.doc(existingProduct.id).update({
            'price': product['price'],
            'description': product['description'],
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Product data successfully added or updated!')),
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
          final icon =
              _getIconFromString(iconString); // Map string to actual Icon
          print('Category: $title, Icon: $icon');
        }
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Helper function to map string icon names to actual Icons
  Icon _getIconFromString(String iconString) {
    switch (iconString) {
      case 'electrical_services':
        return const Icon(Icons.electrical_services);
      case 'shopping_bag':
        return const Icon(Icons.shopping_bag);
      case 'book':
        return const Icon(Icons.book);
      case 'run_circle':
        return const Icon(Icons.run_circle);
      case 'local_grocery_store':
        return const Icon(Icons.local_grocery_store);
      default:
        return const Icon(Icons.help); // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (profilePicPath != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePicPath!),
              ),
            const SizedBox(height: 10),
            Text(
              'Welcome, $userEmail',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCategoryData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Category Data',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProductData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Product Data',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

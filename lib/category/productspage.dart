import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:van_app_demo/cart_page.dart'; // Import the CartPage

class ProductsPage extends StatefulWidget {
  final String categoryTitle;

  const ProductsPage({super.key, required this.categoryTitle});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Map<String, TextEditingController> controllers = {};
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool hasMoreProducts = true;
  DocumentSnapshot? lastDocument;
  int currentPage = 1; // Track current page
  int totalPages = 1; // Track total pages

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    final productCollection = FirebaseFirestore.instance.collection('product');

    try {
      // Fetching products for the current page
      Query query = productCollection
          .where('category', isEqualTo: widget.categoryTitle)
          .limit(10);

      if (currentPage > 1 && lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          lastDocument = snapshot.docs.last;
          hasMoreProducts = snapshot.docs.length == 10;

          // If it's the first page, replace the product list; otherwise, append
          if (currentPage == 1) {
            products = snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
          } else {
            products.addAll(snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList());
          }
        });

        // Fetch total product count (not from snapshot)
        await _fetchTotalProductsCount();
        
        // Initialize controllers for new products
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

  Future<void> _fetchTotalProductsCount() async {
    try {
      final productCollection = FirebaseFirestore.instance.collection('product');
      final snapshot = await productCollection
          .where('category', isEqualTo: widget.categoryTitle)
          .get();

      final totalProducts = snapshot.size; // Get the total count from the snapshot
      totalPages = (totalProducts / 10).ceil(); // Calculate total pages
    } catch (e) {
      print('Error fetching total product count: $e');
    }
  }

  void _addToGlobalCart() {
    for (var product in products) {
      final productName = product['title'] ?? 'Unknown';
      final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

      if (quantity > 0) {
        final existingIndex = Cart.selectedProducts.indexWhere((p) => p['title'] == productName);

        if (existingIndex >= 0) {
          Cart.selectedProducts[existingIndex]['quantity'] += quantity;
        } else {
          Cart.selectedProducts.add({
            ...product,
            'quantity': quantity,
          });
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Products added to cart!')),

    );
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _goToPage(int page) {
    if (page > 0 && page <= totalPages && page != currentPage) {
      setState(() {
        currentPage = page;
        products.clear();
      });
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading && products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final productName = product['title'] ?? 'Unknown';
                        final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    productName,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle),
                                        color: Colors.red,
                                        onPressed: () {
                                          setState(() {
                                            if (quantity > 0) {
                                              controllers[productName]?.text =
                                                  (quantity - 1).toString();
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            controllers[productName]?.text =
                                                (quantity + 1).toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: controllers[productName],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Qty',
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        final newQuantity = int.tryParse(value) ?? 0;
                                        controllers[productName]?.text =
                                            newQuantity < 0 ? '0' : newQuantity.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Pagination above the footer
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalPages,
                      (index) => GestureDetector(
                        onTap: () {
                          _goToPage(index + 1);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: currentPage == (index + 1)
                              ? Colors.teal
                              : Colors.grey,
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
                // Footer with buttons
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

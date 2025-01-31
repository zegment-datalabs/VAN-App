import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bottomsheet extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onAddProduct;


  const Bottomsheet({Key? key, required this.onAddProduct}) : super(key: key);

  @override
  BottomsheetState createState() => BottomsheetState();
}

class BottomsheetState extends State<Bottomsheet> {
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

  // Function to filter products based on search query
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

  // Function to update the list of products with modified quantities
  void _updateProductList() {
  List<Map<String, dynamic>> selectedProducts = [];

  for (var product in filteredProducts) {
    final productName = product['title'] ?? 'Unknown';
    final quantity = int.tryParse(controllers[productName]?.text ?? '0') ?? 0;

    if (quantity > 0) {
      selectedProducts.add({
        'Product Name': productName,
        'Category Name': product['category'] ?? 'Unknown',
        'sellingprice': product['selling_price'] ?? 0.0,
        'quantity': quantity,
      });
    }
  }

  //  Send all selected products to parent
  if (selectedProducts.isNotEmpty) {
    widget.onAddProduct(selectedProducts);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No products selected!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
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
                                          '\₹ $sellingPrice',
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
                                                  int.tryParse(controllers[productName]
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
                                                  int.tryParse(controllers[productName]
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
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                        ),
                                        style: const TextStyle(fontSize: 14.0),
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
                // Add button in footer
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: _updateProductList,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
    );
  }
}

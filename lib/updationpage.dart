import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:van_app_demo/category/allproducts.dart';



class UpdationPage extends StatefulWidget {
  @override
  _UpdationPageState createState() => _UpdationPageState();
}

class _UpdationPageState extends State<UpdationPage> {
  String? selectedOrderId;
  List<String> orderIds = [];
  Map<String, dynamic>? orderDetails;
  List<Map<String, dynamic>> orderItems = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isSearchVisible = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchOrderIds();
  }
  

  Future<void> fetchOrderIds() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
        .collection('order_masters')
        .where('customerId', isEqualTo: user.email)
        .get();

    setState(() {
      orderIds = ordersSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> fetchOrderDetails(String orderId) async {
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('order_masters')
        .doc(orderId)
        .get();

    QuerySnapshot orderItemsSnapshot = await FirebaseFirestore.instance
        .collection('order_masters')
        .doc(orderId)
        .collection('order_details')
        .get();

    setState(() {
      orderDetails = orderSnapshot.data() as Map<String, dynamic>?;
      orderItems = orderItemsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var item in orderItems) {
      totalAmount += (double.tryParse(item['sellingprice']?.toString() ?? '0.0') ?? 0.0) * item['quantity'];
    }
    return totalAmount;
  }

  int calculateTotalQuantity() {
  int totalQuantity = 0;
  for (var item in orderItems) {
    totalQuantity += (item['quantity'] as num).toInt(); // Cast the num to int
  }
  return totalQuantity;
}



Future<void> refreshData() async {
  setState(() {
    orderIds.clear();
    orderItems.clear();
    orderDetails = null;
  });

  // Fetch orderIds and refresh order details
  await fetchOrderIds();
  if (selectedOrderId != null) {
    await fetchOrderDetails(selectedOrderId!);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Data Refreshed Successfully')),
  );
}


Future<void> updateOrder(String orderId) async {
  try {
    // Get the reference to the order document
    DocumentReference orderDocRef = FirebaseFirestore.instance.collection('order_masters').doc(orderId);

    // Update the order master document
    print("Updating order master...");
    await orderDocRef.update({
      'orderValue': calculateTotalAmount(), // Update the order value with the new total
      'status': 'Updated', // Update the status
      'orderTime': FieldValue.serverTimestamp(), // Set current timestamp for orderTime
    });
    print("Order master updated successfully.");

    // Handle updates to the order items
    for (var item in orderItems) {
      String title = item['Product Name']; // Use title here instead of productId

      if (title == null || title.isEmpty) {
        print("Error: Missing title for item, skipping update.");
        continue; // Skip this item
      }

      print("Updating item with title: $title");

      // Find the corresponding order item by title
      QuerySnapshot orderItemsSnapshot = await FirebaseFirestore.instance
          .collection('order_masters')
          .doc(orderId)
          .collection('order_details')
          .where('Product Name', isEqualTo: title) // Query by product name
          .get();

      if (orderItemsSnapshot.docs.isEmpty) {
        print("No order item found with title: $title. Skipping update.");
      } else {
        // Get the reference of the first matching document (assuming title is unique)
        DocumentReference orderItemDocRef = orderItemsSnapshot.docs.first.reference;

        // Update the order item (quantity and selling price)
        double? sellingprice = item['sellingprice'];
        if (sellingprice == null) {
          print("Warning: Selling price is null for title: $title. Setting it to 0.");
          sellingprice = 0.0; // Default value for price if null
        }

        print("Updating order item: Quantity - ${item['quantity']}, Selling Price - $sellingprice");

        await orderItemDocRef.update({
          'quantity': item['quantity'], // Updated quantity
          'sellingprice': sellingprice, // Updated selling price
          'Category Name': item['Category Name'], // Update category name
          'Product Name': item['Product Name'], // Update product name
        });
        print("Item with title: $title updated successfully.");
      }
    }

    // Handle item deletions (items removed from the order)
    List<String> currentTitles = orderItems.map((item) => item['Product Name'] as String).toList();

    QuerySnapshot orderItemsSnapshot = await FirebaseFirestore.instance
        .collection('order_masters')
        .doc(orderId)
        .collection('order_details')
        .get();

    for (var doc in orderItemsSnapshot.docs) {
      if (!currentTitles.contains(doc['Product Name'])) { // Compare by Product Name
        // This item has been removed from the order in the app
        await doc.reference.delete();
        print("Removed item with title: ${doc['Product Name']} from Firestore.");
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order Updated Successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
    print("Error during update: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    // Filter order items based on search query
    final filteredOrderItems = orderItems.where((item) {
      final productTitle = item['Product Name']?.toLowerCase() ?? '';
      return productTitle.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Order'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllProductsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
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
          IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: refreshData, // Call the refreshData method
    ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedOrderId,
              hint: const Text('Select Order ID'),
              items: orderIds.map((orderId) {
                return DropdownMenuItem(
                  value: orderId,
                  child: Text(orderId),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOrderId = value;
                  orderDetails = null;
                  orderItems = [];
                });
                if (value != null) fetchOrderDetails(value);
              },
            ),
            const SizedBox(height: 20),
            if (orderDetails != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${orderDetails!['orderId']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Customer ID: ${orderDetails!['customerId']}'),
                      Text('Van ID: ${orderDetails!['vanId']}'),
                      Text('Order Total: ₹${orderDetails!['orderValue']}'),
                      Text('Status: ${orderDetails!['status']}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Search bar visibility toggle
              if (isSearchVisible)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
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
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 10),
              const Text('Ordered Products:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: filteredOrderItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 5, 5),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredOrderItems.length,
                        itemBuilder: (context, index) {
                          var item = filteredOrderItems[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 0.0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              title: Text(
                                item['Product Name'] ?? 'Unknown Product',
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
                                    'Category: ${item['Category Name'] ?? 'Unknown'}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Quantity: ${item['quantity'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '₹${(double.tryParse(item['sellingprice']?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
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
                                        if (item['quantity'] > 1) {
                                          item['quantity']--;
                                        } else {
                                          orderItems.removeAt(index);
                                        }
                                      });
                                    },
                                  ),
                                  // Increment quantity
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        item['quantity']++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
            const SizedBox(height: 16.0),
            // Footer with Total and Place Order Button
            if (orderItems.isNotEmpty) ...[
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
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
                    ElevatedButton(
  onPressed: orderItems.isEmpty
      ? null
      : () {
          if (selectedOrderId != null) {
            updateOrder(selectedOrderId!); // Call the update function
          }
        },
  style: ElevatedButton.styleFrom(
    backgroundColor: orderItems.isEmpty ? Colors.grey : Colors.teal,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  child: const Text(
    'Update',
    style: TextStyle(fontSize: 16.0),
  ),
),

                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

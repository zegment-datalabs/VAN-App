import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:van_app_demo/bottomsheet.dart';

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

  List<Map<String, dynamic>> newProduct = [];

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
      orderItems = orderItemsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void _updateProductList(List<Map<String, dynamic>> newProducts) {
    setState(() {
      for (var newProduct in newProducts) {
        final productName = newProduct['Product Name'] ?? 'Unknown';
        final existingIndex = orderItems
            .indexWhere((item) => item['Product Name'] == productName);

        if (existingIndex != -1) {
          orderItems[existingIndex]['quantity'] = newProduct['quantity'];
        } else {
          orderItems.add(newProduct);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newProducts.length} product(s) added!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

 double calculateTotalAmount() {
  double totalAmount = 0.0;
  for (var item in orderItems) {
    double price = double.tryParse(item['sellingprice']?.toString() ?? '0.0') ?? 0.0;
    double quantity = (item['quantity'] as num).toDouble(); // Ensure it's double
    totalAmount += price * quantity;
  }
  return double.parse(totalAmount.toStringAsFixed(2)); // Ensure only 2 decimal places
}

String calculateTotalQuantity() {
  double totalQuantity = 0.0;
  for (var item in orderItems) {
    totalQuantity += (item['quantity'] as num).toDouble(); // Convert to double
  }
  return totalQuantity.toStringAsFixed(2); // Ensure exactly 2 decimal places
}


  Future<void> refreshData() async {
    setState(() {
      orderIds.clear();
      orderItems.clear();
      orderDetails = null;
    });

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
    DocumentReference orderDocRef =
        FirebaseFirestore.instance.collection('order_masters').doc(orderId);

    await orderDocRef.update({
      'orderValue': calculateTotalAmount(),
      'status': 'Updated',
      'orderTime': FieldValue.serverTimestamp(),
    });

    for (var item in orderItems) {
      String title = item['Product Name'];
      if (title.isEmpty) {
        print("Error: Missing title for item, skipping update.");
        continue;
      }

      QuerySnapshot orderItemsSnapshot = await FirebaseFirestore.instance
          .collection('order_masters')
          .doc(orderId)
          .collection('order_details')
          .where('Product Name', isEqualTo: title)
          .get();

      if (item['quantity'] == 0) {
        // If quantity is 0, delete the item
        for (var doc in orderItemsSnapshot.docs) {
          await doc.reference.delete();
        }
        continue;
      }

      if (orderItemsSnapshot.docs.isEmpty) {
        // Insert new product
        await FirebaseFirestore.instance
            .collection('order_masters')
            .doc(orderId)
            .collection('order_details')
            .add({
          'orderId': orderId,
          'Product Name': item['Product Name'],
          'Category Name': item['Category Name'],
          'quantity': item['quantity'],
          'sellingprice': item['sellingprice'] ?? 0.0,
        });
      } else {
        // Update existing product
        DocumentReference orderItemDocRef = orderItemsSnapshot.docs.first.reference;
        await orderItemDocRef.update({
          'quantity': item['quantity'],
          'sellingprice': item['sellingprice'],
          'Category Name': item['Category Name'],
        });
      }
    }

    // Remove products that are no longer in orderItems
    List<String> currentTitles =
        orderItems.map((item) => item['Product Name'] as String).toList();

    QuerySnapshot orderItemsSnapshot = await FirebaseFirestore.instance
        .collection('order_masters')
        .doc(orderId)
        .collection('order_details')
        .get();

    for (var doc in orderItemsSnapshot.docs) {
      if (!currentTitles.contains(doc['Product Name'])) {
        await doc.reference.delete();
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
Future<void> cancelOrder(String orderId) async {
  try {
    DocumentReference orderDocRef =
        FirebaseFirestore.instance.collection('order_masters').doc(orderId);

    // Delete the order document
    await orderDocRef.delete();

    // Optionally, delete the associated order details (order_items) as well.
    QuerySnapshot orderItemsSnapshot = await FirebaseFirestore.instance
        .collection('order_masters')
        .doc(orderId)
        .collection('order_details')
        .get();

    for (var doc in orderItemsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order Deleted Successfully')),
    );

    // Clear selected order ID and reset the UI
    setState(() {
      selectedOrderId = null;
      orderDetails = null;
      orderItems.clear();
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
    print("Error during deletion: $e");
  }
}
@override
Widget build(BuildContext context) {
  final filteredOrderItems = orderItems.where((item) {
    final productTitle = item['Product Name']?.toLowerCase() ?? '';
    return productTitle.contains(searchQuery.toLowerCase());
  }).toList();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Update/Cancel Order'),
      backgroundColor: Colors.teal,
      centerTitle: true,
      actions: [
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
          onPressed: refreshData,
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: selectedOrderId,
            hint: const Text('Select Order ID'),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            items: orderIds.map((orderId) {
              return DropdownMenuItem(
                value: orderId,
                child: Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${orderDetails!['orderId']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('Customer ID: ${orderDetails!['customerId']}'),
                    Text('Van ID: ${orderDetails!['vanId']}'),
                    Text('Order Total: ₹${calculateTotalAmount().toStringAsFixed(2)}'),
                    Text('Status: ${orderDetails!['status']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
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
            const Text('Ordered Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          shrinkWrap: true, // Shrinks the ListView to only the visible content
          itemCount: filteredOrderItems.length,
          itemBuilder: (context, index) {
            var item = filteredOrderItems[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Reduce padding to make card smaller
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['Product Name'] ?? 'Unnamed Product',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      item['Category Name'] ?? 'Unnamed Category',
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 92, 91, 91),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  int currentQuantity = item['quantity'];
                                  if (currentQuantity > 0) {
                                    item['quantity'] -= 1;
                                  }
                                });
                              },
                            ),
                            Text('Qty: ${item['quantity']}'),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  item['quantity'] += 1;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color:  Color.fromARGB(255, 139, 28, 20),),
                              onPressed: () async {
                                bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Confirm Deletion"),
                                    content: const Text("Are you sure you want to delete this product?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  setState(() {
                                    orderItems.removeAt(index);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Text(
                          '₹${(item['sellingprice'] ?? 0.0) * item['quantity']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
)

          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedOrderId != null) {
                      updateOrder(selectedOrderId!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select an order to update.')),
                      );
                    }
                  },
                  child: const Text('Update Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Gradient Color from teal to light blue
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.tealAccent,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedOrderId != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Cancellation"),
                          content: const Text("Are you sure you want to cancel and delete this order?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); 
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); 
                                cancelOrder(selectedOrderId!);  
                              },
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select an order to cancel.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // Gradient Color for Cancel Button
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.orange,
                  ),
                  child: const Text('Cancel Order'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.all(12.0),
      color: Colors.teal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
                'Total Quantity: ${calculateTotalQuantity()}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Total Amount: ₹${calculateTotalAmount().toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),

        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: selectedOrderId == null
          ? null
          : () async {
              final newProducts = await showModalBottomSheet<List<Map<String, dynamic>>>( 
                context: context,
                builder: (context) {
                  return Bottomsheet(
                    onAddProduct: (newProduct) {
                      _updateProductList(newProduct);
                    },
                    orderedProducts: orderItems,
                  );
                },
              );

              if (newProducts != null) {
                _updateProductList(newProducts);
              }
            },
      child: Icon(Icons.add),
      backgroundColor: selectedOrderId == null ? Colors.grey : Colors.teal,
    ),
  );
}

}
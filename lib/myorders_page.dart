import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('order_masters')
          .where('customer_id')
          .get();

      setState(() {
        orders = ordersSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching orders: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrderProducts(String order_id) async {
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('order_masters')
          .doc(order_id)
          .collection('order_details')
          .get();

      return productSnapshot.docs.map((doc) {
        var productData = doc.data() as Map<String, dynamic>;
        productData['Product Name'] = productData['Product Name'] ?? 'No Name';
        return productData;
      }).toList();
    } catch (e) {
      print("Error fetching products for order $order_id: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    'No Orders Found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: ${order['order_id']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 8, 8, 8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Total: ₹${order['order_value']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Chip(
                                  label: Text(order['status']),
                                  backgroundColor: _getStatusColor(order['status']),
                                  labelStyle: const TextStyle(color: Color.fromARGB(255, 19, 17, 17)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Order Date: ${_formatDate(order['order_time'])}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),

                            // Fetch and display the products for this order
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: fetchOrderProducts(order['order_id']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return const Text(
                                    'Error loading products',
                                    style: TextStyle(color:  Color.fromARGB(255, 139, 28, 20),),
                                  );
                                }

                                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Products in Order:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      ...snapshot.data!.map((product) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('• ', style: TextStyle(fontSize: 14)),
                                              Expanded(
                                                child: Text(
                                                  '${product['Product Name']} - Qty: ${product['quantity'] ?? 0}',
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                } else {
                                  return const Text('No Products Found');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  /// Function to get color based on order status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  /// Function to format date properly
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown Date';
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }
}
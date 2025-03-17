import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/login_page.dart';

class OrderIdGenerator {
  int _counter = 0;

  Future<void> setCounter(int counter) async {
    _counter = counter;
  }

  String _getIncrementedCounter() {
    // Increment counter and format it as 000X
    _counter = (_counter + 1) % 10; // This will reset after reaching 9
    return _counter.toString().padLeft(3, '0');
  }
}

class ConfirmationPage extends StatelessWidget {
  final double orderValue;
  final double quantity;
  final List<Map<String, dynamic>> selectedProducts;
  const ConfirmationPage({
    super.key,
    required this.orderValue,
    required this.quantity,
    required this.selectedProducts,
  });

  Future<String> generateOrderId() async {
    DateTime now = DateTime.now();
    String dateKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}"; // YYYY-MM-DD format for the key

    // Base order_id without the counter
    String formattedOrderId = "${now.day.toString().padLeft(2, '0')}"
        "${now.month.toString().padLeft(2, '0')}"
        "${now.year}";

    // Firestore transaction for counter increment
    DocumentReference counterRef =
        FirebaseFirestore.instance.collection('order_counter').doc(dateKey);

    try {
      String finalOrderId =
          await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the current counter value for today
        DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

        int counter = 0;
        if (counterSnapshot.exists) {
          counter = counterSnapshot['counter'] ?? 0;
        }

        // Increment the counter and ensure it resets at 9999
        int newCounter =
            (counter + 1) % 10000; // Allow up to 9999 increments per day

        // Set the new counter value atomically
        transaction.set(
            counterRef, {'counter': newCounter}, SetOptions(merge: true));

        // Generate the final order ID with the new counter value
        return formattedOrderId +
            newCounter.toString().padLeft(4, '0'); // Ensure counter is 4 digits
      });

      return finalOrderId;
    } catch (e) {
      throw Exception("Error generating order ID: $e");
    }
  }

  Future<Map<String, dynamic>> getCustomerDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("User is not logged in");
    }

    String? userEmail = currentUser.email;
    String? userPhone = currentUser.phoneNumber;

    QuerySnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customer')
        .where('customer_email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (customerSnapshot.docs.isEmpty && userPhone != null) {
      // If email-based query fails, try phone-based lookup
      customerSnapshot = await FirebaseFirestore.instance
          .collection('customer')
          .where('customer_contact', isEqualTo: userPhone)
          .limit(1)
          .get();
    }

    if (customerSnapshot.docs.isNotEmpty) {
      var customerData =
          customerSnapshot.docs.first.data() as Map<String, dynamic>;
      return {
        'customer_id': customerData['customer_id'] ?? 0,
        'van_id': customerData['van_id'] ?? 0,
      };
    } else {
      throw Exception("Customer not found in database.");
    }
  }

  Future<Map<String, dynamic>> addOrderToFirebase() async {
    try {
      Map<String, dynamic> customerData = await getCustomerDetails();
      int customer_id = customerData['customer_id'];
      int van_id = customerData['van_id'];

      String order_id = await generateOrderId();

      await FirebaseFirestore.instance
          .collection('order_masters')
          .doc(order_id)
          .set({
        'customer_id': customer_id,
        'order_time': FieldValue.serverTimestamp(),
        'order_id': order_id,
        'order_value': orderValue,
        'van_id': van_id,
        'status': 'Pending',
      });

      for (var product in selectedProducts) {
        await FirebaseFirestore.instance
            .collection('order_masters')
            .doc(order_id)
            .collection('order_details')
            .add({
          "Product Name": product['title'] ?? '',
          "quantity": product['quantity'] ?? 1,
          "Category Name": product['category'] ?? '',
          "order_id": order_id,
          "selling_price": product['sellingPrice'] ?? 0.0,
        });
      }

      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('order_masters')
          .doc(order_id)
          .get();

      return {
        'order_id': order_id,
        'customer_id': customer_id,
        'van_id': van_id,
        'order_time': orderSnapshot['order_time'],
        'order_value': orderValue,
      };
    } catch (e) {
      print("Error adding order: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text('Order Confirmation',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: addOrderToFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (snapshot.hasData) {
              var orderData = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Display Order ID prominently at the top
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        child: Text(
                          'Order ID: ${orderData['order_id']}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 11, 12, 12),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Icon and confirmation message
                    const Icon(
                      Icons.check_circle_outline,
                      size: 100.0,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Order Successfully Placed!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: const Color.fromARGB(
                          255, 6, 126, 96), // Set background color here
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer ID: ${orderData['customer_id']}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            Text(
                              'Van ID: ${orderData['van_id']}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            Text(
                              'Order Time: ${orderData['order_time']?.toDate()?.toString()}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            Text(
                              'Order Total: ₹${orderData['order_value'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    const Text(
                      'Ordered Products',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedProducts.length,
                      itemBuilder: (context, index) {
                        var product = selectedProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          color: const Color.fromARGB(
                              255, 6, 126, 96), // Set background color here
                          child: ListTile(
                            title: Text(
                              product['title'] ?? 'Unknown Product',
                              style: const TextStyle(
                                color: Colors
                                    .white, // White text for better contrast
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Category: ${product['category']}',
                              style: const TextStyle(
                                color: Color(0xFFF5F5F5),
                              ),
                            ),
                            trailing: Text(
                              'Qty: ${product['quantity']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(
                            16), // Increase padding for a bigger button
                        shape: const CircleBorder(),
                        backgroundColor: Colors.teal, // Background color
                      ),
                      child: const Icon(
                        Icons.home,
                        size: 30, // Increase icon size
                        color: Colors.white, // Set icon color to black
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 56, 28, 1)),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}

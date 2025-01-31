import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:van_app_demo/homepage.dart';
import 'package:van_app_demo/updationpage.dart';

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

class OrderPage extends StatelessWidget {
  final double orderValue;
  final double quantity;
  final List<Map<String, dynamic>> selectedProducts;

  OrderPage({
    super.key,
    required this.orderValue,
    required this.quantity,
    required this.selectedProducts,
  });

  Future<Map<String, String>> ensureCustomerId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User is not logged in");
    }

    String customerId =
        currentUser.email ?? currentUser.phoneNumber ?? "anonymous";
    String vanId = await generateVanId();

    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userDoc);

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        if (userData['customerId'] != null && userData['vanId'] != null) {
          return {
            'customerId': userData['customerId'],
            'vanId': userData['vanId']
          };
        }
      }

      transaction.set(
        userDoc,
        {
          'customerId': customerId,
          'vanId': vanId,
        },
        SetOptions(merge: true),
      );

      return {
        'customerId': customerId,
        'vanId': vanId,
      };
    });
  }

  Future<String> generateVanId() async {
    return "1"; // Assuming a single van for now
  }




Future<String> generateOrderId() async {
  DateTime now = DateTime.now();
  String dateKey = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}"; // YYYY-MM-DD format for the key

  // Base orderId without the counter
  String formattedOrderId = "${now.day.toString().padLeft(2, '0')}"
      "${now.month.toString().padLeft(2, '0')}"
      "${now.year}";

  // Firestore transaction for counter increment
  DocumentReference counterRef =
      FirebaseFirestore.instance.collection('order_counter').doc(dateKey);

  try {
    String finalOrderId = await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the current counter value for today
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

      int counter = 0;
      if (counterSnapshot.exists) {
        counter = counterSnapshot['counter'] ?? 0;
      }

      // Increment the counter and ensure it resets at 9999
      int newCounter = (counter + 1) % 10000; // Allow up to 9999 increments per day

      // Set the new counter value atomically
      transaction.set(counterRef, {'counter': newCounter}, SetOptions(merge: true));

      // Generate the final order ID with the new counter value
      return formattedOrderId + newCounter.toString().padLeft(4, '0'); // Ensure counter is 4 digits
    });

    return finalOrderId;
  } catch (e) {
    throw Exception("Error generating order ID: $e");
  }
}






  Future<Map<String, dynamic>> addOrderToFirebase() async {
  try {
    Map<String, String> userIds = await ensureCustomerId();
    String customerId = userIds['customerId'] ?? "anonymous";
    String vanId = userIds['vanId'] ?? "unknown";

    String orderId = await generateOrderId(); // Use this for both collections

    // Add the order to the "order_masters" collection
    await FirebaseFirestore.instance
        .collection('order_masters')
        .doc(orderId)
        .set({
      'customerId': customerId,
      'orderTime': FieldValue.serverTimestamp(),
      'orderId': orderId,  // Use the same orderId
      'orderValue': orderValue,
      'vanId': vanId,
      'status': 'Pending',
    });

    // Add the order details to the "order_details" sub-collection
    for (var product in selectedProducts) {
      await FirebaseFirestore.instance
          .collection('order_masters')
          .doc(orderId)
          .collection('order_details')
          .add({
        "Product Name": product['title'] ?? '',
        "quantity": product['quantity'] ?? 1,
        "Category Name": product['category'] ?? '',
        "orderId": orderId, // Use the same orderId here
        "sellingprice": product['sellingPrice'] ?? 0.0,
      });
    }

    // Retrieve the order details to return
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('order_masters')
        .doc(orderId)
        .get();

    return {
      'orderId': orderId,
      'customerId': customerId,
      'vanId': vanId,
      'orderTime': orderSnapshot['orderTime'],
      'orderValue': orderValue,
    };
  } catch (e) {
    print("Error adding order: $e");
    rethrow;
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Order Confirmation')),
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
      'Order ID: ${orderData['orderId']}',
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            Text(
                              'Customer ID: ${orderData['customerId']}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Van ID: ${orderData['vanId']}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Order Time: ${orderData['orderTime']?.toDate()?.toString()}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Order Total: ₹${orderData['orderValue'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Ordered Products',
                      style:
                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                          child: ListTile(
                            title: Text(product['title'] ?? 'Unknown Product'),
                            subtitle: Text('Category: ${product['category']}'),
                            trailing: Text('Qty: ${product['quantity']}'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                      ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage()), 
                        );
                      },
                      child: const Text('Back to Home'),
                    ),
                    const SizedBox(height: 20),
                      ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdationPage()), 
                        );
                      },
                      child: const Text('Update'),
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

import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: const Center(
        child: Text('Orders will be displayed here.'),
      ),
    );
  }
<<<<<<< HEAD
}
// import 'package:flutter/material.dart';

// class OrderPage extends StatelessWidget {
//   const OrderPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Orders'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Text
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.0),
//               child: Text(
//                 'Your Recent Orders',
//                 style: TextStyle(
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal,
//                 ),
//               ),
//             ),
            
//             // Example Orders List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 5, // Replace with dynamic data from your backend
//                 itemBuilder: (context, index) {
//                   return OrderCard(
//                     orderNumber: 'Order #${index + 1}',
//                     orderDate: 'January 21, 2025',
//                     orderTotal: '\$50.00',
//                     onTap: () {
//                       // Handle navigation to order details or actions
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => OrderDetailPage(orderId: index + 1)),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Order Card widget to display individual order
// class OrderCard extends StatelessWidget {
//   final String orderNumber;
//   final String orderDate;
//   final String orderTotal;
//   final VoidCallback onTap;

//   const OrderCard({
//     required this.orderNumber,
//     required this.orderDate,
//     required this.orderTotal,
//     required this.onTap,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             children: [
//               // Order Number and Date
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     orderNumber,
//                     style: const TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4.0),
//                   Text(
//                     'Placed on: $orderDate',
//                     style: const TextStyle(
//                       fontSize: 14.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               // Order Total
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     orderTotal,
//                     style: const TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 4.0),
//                   const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 16.0,
//                     color: Colors.teal,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Example Order Detail Page (for navigation)
// class OrderDetailPage extends StatelessWidget {
//   final int orderId;

//   const OrderDetailPage({required this.orderId, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Details')),
//       body: Center(
//         child: Text('Details for Order #$orderId'),
//       ),
//     );
//   }
// }
=======
}
>>>>>>> 12dbdc151dfc2cdcfdcf54d59090552f704053de

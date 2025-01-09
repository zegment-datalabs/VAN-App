import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  final String categoryTitle;

  const ProductsPage({super.key, required this.categoryTitle});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // Dummy product data for each category with initial quantities and controllers
  final Map<String, List<Map<String, dynamic>>> categoryProducts = {
    // dummy_data

  'Electronics': [
    {'name': 'Smartphone', 'price': 299.99, 'quantity': 0},
    {'name': 'Laptop', 'price': 799.99, 'quantity': 0},
    {'name': 'Headphones', 'price': 49.99, 'quantity': 0},
    {'name': 'Smartwatch', 'price': 199.99, 'quantity': 0},
    {'name': 'Tablet', 'price': 249.99, 'quantity': 0},
    {'name': 'Bluetooth Speaker', 'price': 59.99, 'quantity': 0},
    {'name': 'Camera', 'price': 399.99, 'quantity': 0},
    {'name': 'Drone', 'price': 499.99, 'quantity': 0},
    {'name': 'Gaming Console', 'price': 399.99, 'quantity': 0},
    {'name': 'VR Headset', 'price': 249.99, 'quantity': 0},
  ],
  'Clothing': [
    {'name': 'T-Shirt', 'price': 19.99, 'quantity': 0},
    {'name': 'Jeans', 'price': 39.99, 'quantity': 0},
    {'name': 'Jacket', 'price': 89.99, 'quantity': 0},
    {'name': 'Sneakers', 'price': 59.99, 'quantity': 0},
    {'name': 'Sweater', 'price': 29.99, 'quantity': 0},
    {'name': 'Shorts', 'price': 24.99, 'quantity': 0},
    {'name': 'Hat', 'price': 15.99, 'quantity': 0},
    {'name': 'Scarf', 'price': 12.99, 'quantity': 0},
    {'name': 'Boots', 'price': 89.99, 'quantity': 0},
    {'name': 'Gloves', 'price': 9.99, 'quantity': 0},
  ],
  'Books': [
    {'name': 'The Great Gatsby', 'price': 14.99, 'quantity': 0},
    {'name': '1984', 'price': 12.99, 'quantity': 0},
    {'name': 'Moby Dick', 'price': 17.99, 'quantity': 0},
    {'name': 'To Kill a Mockingbird', 'price': 13.99, 'quantity': 0},
    {'name': 'The Catcher in the Rye', 'price': 10.99, 'quantity': 0},
    {'name': 'Pride and Prejudice', 'price': 11.99, 'quantity': 0},
    {'name': 'War and Peace', 'price': 19.99, 'quantity': 0},
    {'name': 'The Odyssey', 'price': 15.99, 'quantity': 0},
    {'name': 'Crime and Punishment', 'price': 13.99, 'quantity': 0},
    {'name': 'Brave New World', 'price': 14.99, 'quantity': 0},
  ],
  'Shoes': [
    {'name': 'Running Shoes', 'price': 59.99, 'quantity': 0},
    {'name': 'Boots', 'price': 89.99, 'quantity': 0},
    {'name': 'Sandals', 'price': 29.99, 'quantity': 0},
    {'name': 'Sneakers', 'price': 69.99, 'quantity': 0},
    {'name': 'Loafers', 'price': 49.99, 'quantity': 0},
    {'name': 'Flip Flops', 'price': 14.99, 'quantity': 0},
    {'name': 'High Heels', 'price': 99.99, 'quantity': 0},
    {'name': 'Slippers', 'price': 19.99, 'quantity': 0},
    {'name': 'Work Boots', 'price': 79.99, 'quantity': 0},
    {'name': 'Dress Shoes', 'price': 89.99, 'quantity': 0},
  ],
  'Groceries': [
    {'name': 'Milk', 'price': 1.99, 'quantity': 0},
    {'name': 'Eggs', 'price': 2.99, 'quantity': 0},
    {'name': 'Bread', 'price': 1.49, 'quantity': 0},
    {'name': 'Apples', 'price': 3.99, 'quantity': 0},
    {'name': 'Bananas', 'price': 2.49, 'quantity': 0},
    {'name': 'Carrots', 'price': 1.99, 'quantity': 0},
    {'name': 'Tomatoes', 'price': 3.49, 'quantity': 0},
    {'name': 'Cheese', 'price': 4.99, 'quantity': 0},
    {'name': 'Chicken', 'price': 5.99, 'quantity': 0},
    {'name': 'Rice', 'price': 2.99, 'quantity': 0},
  ],
  'Toys': [
    {'name': 'Action Figure', 'price': 9.99, 'quantity': 0},
    {'name': 'Doll', 'price': 14.99, 'quantity': 0},
    {'name': 'Toy Car', 'price': 7.99, 'quantity': 0},
    {'name': 'Puzzle', 'price': 12.99, 'quantity': 0},
    {'name': 'Building Blocks', 'price': 19.99, 'quantity': 0},
    {'name': 'Stuffed Animal', 'price': 10.99, 'quantity': 0},
    {'name': 'Board Game', 'price': 24.99, 'quantity': 0},
    {'name': 'Remote Control Helicopter', 'price': 29.99, 'quantity': 0},
    {'name': 'Toy Train Set', 'price': 49.99, 'quantity': 0},
    {'name': 'Bicycle', 'price': 99.99, 'quantity': 0},
  ],
  'Beauty Products': [
    {'name': 'Shampoo', 'price': 5.99, 'quantity': 0},
    {'name': 'Conditioner', 'price': 6.49, 'quantity': 0},
    {'name': 'Face Cream', 'price': 12.99, 'quantity': 0},
    {'name': 'Lipstick', 'price': 9.99, 'quantity': 0},
    {'name': 'Nail Polish', 'price': 4.99, 'quantity': 0},
    {'name': 'Perfume', 'price': 29.99, 'quantity': 0},
    {'name': 'Face Mask', 'price': 7.99, 'quantity': 0},
    {'name': 'Toothpaste', 'price': 2.99, 'quantity': 0},
    {'name': 'Deodorant', 'price': 3.99, 'quantity': 0},
    {'name': 'Hand Cream', 'price': 6.99, 'quantity': 0},
  ],
  'Sports': [
    {'name': 'Football', 'price': 19.99, 'quantity': 0},
    {'name': 'Basketball', 'price': 24.99, 'quantity': 0},
    {'name': 'Tennis Racket', 'price': 49.99, 'quantity': 0},
    {'name': 'Baseball Bat', 'price': 29.99, 'quantity': 0},
    {'name': 'Soccer Shoes', 'price': 59.99, 'quantity': 0},
    {'name': 'Yoga Mat', 'price': 19.99, 'quantity': 0},
    {'name': 'Dumbbells', 'price': 39.99, 'quantity': 0},
    {'name': 'Bicycle', 'price': 159.99, 'quantity': 0},
    {'name': 'Swimming Goggles', 'price': 15.99, 'quantity': 0},
    {'name': 'Boxing Gloves', 'price': 34.99, 'quantity': 0},
  ],
  'Health': [
    {'name': 'Vitamins', 'price': 19.99, 'quantity': 0},
    {'name': 'First Aid Kit', 'price': 29.99, 'quantity': 0},
    {'name': 'Hand Sanitizer', 'price': 3.99, 'quantity': 0},
    {'name': 'Pain Relief Cream', 'price': 9.99, 'quantity': 0},
    {'name': 'Thermometer', 'price': 12.99, 'quantity': 0},
    {'name': 'Blood Pressure Monitor', 'price': 49.99, 'quantity': 0},
    {'name': 'Massage Oil', 'price': 7.99, 'quantity': 0},
    {'name': 'Face Mask', 'price': 1.99, 'quantity': 0},
    {'name': 'Cough Syrup', 'price': 6.99, 'quantity': 0},
    {'name': 'Fitness Tracker', 'price': 79.99, 'quantity': 0},
  ],
  'Home Appliances': [
    {'name': 'Washing Machine', 'price': 299.99, 'quantity': 0},
    {'name': 'Microwave Oven', 'price': 79.99, 'quantity': 0},
    {'name': 'Refrigerator', 'price': 499.99, 'quantity': 0},
    {'name': 'Blender', 'price': 49.99, 'quantity': 0},
    {'name': 'Vacuum Cleaner', 'price': 89.99, 'quantity': 0},
    {'name': 'Coffee Maker', 'price': 29.99, 'quantity': 0},
    {'name': 'Air Purifier', 'price': 199.99, 'quantity': 0},
    {'name': 'Iron', 'price': 39.99, 'quantity': 0},
    {'name': 'Toaster', 'price': 19.99, 'quantity': 0},
    {'name': 'Dishwasher', 'price': 399.99, 'quantity': 0},
  ],
  'Gaming': [
    {'name': 'PlayStation 5', 'price': 499.99, 'quantity': 0},
    {'name': 'Xbox Series X', 'price': 499.99, 'quantity': 0},
    {'name': 'Nintendo Switch', 'price': 299.99, 'quantity': 0},
    {'name': 'Gaming Chair', 'price': 149.99, 'quantity': 0},
    {'name': 'Gaming Mouse', 'price': 39.99, 'quantity': 0},
    {'name': 'Gaming Keyboard', 'price': 89.99, 'quantity': 0},
    {'name': 'VR Headset', 'price': 249.99, 'quantity': 0},
    {'name': 'Game Controller', 'price': 59.99, 'quantity': 0},
    {'name': 'Gaming Monitor', 'price': 199.99, 'quantity': 0},
    {'name': 'Headset', 'price': 79.99, 'quantity': 0},
  ],
  'Food & Drink': [
    {'name': 'Apple Juice', 'price': 3.99, 'quantity': 0},
    {'name': 'Water', 'price': 0.99, 'quantity': 0},
    {'name': 'Coke', 'price': 1.49, 'quantity': 0},
    {'name': 'Beer', 'price': 5.99, 'quantity': 0},
    {'name': 'Wine', 'price': 9.99, 'quantity': 0},
    {'name': 'Coffee', 'price': 2.99, 'quantity': 0},
    {'name': 'Tea', 'price': 1.99, 'quantity': 0},
    {'name': 'Snacks', 'price': 1.99, 'quantity': 0},
    {'name': 'Cookies', 'price': 3.49, 'quantity': 0},
    {'name': 'Chips', 'price': 2.49, 'quantity': 0},
  ],
  'Books & Magazines': [
    {'name': 'National Geographic', 'price': 5.99, 'quantity': 0},
    {'name': 'Time Magazine', 'price': 4.99, 'quantity': 0},
    {'name': 'TechCrunch', 'price': 6.99, 'quantity': 0},
    {'name': 'Vogue', 'price': 7.99, 'quantity': 0},
    {'name': 'The Economist', 'price': 8.99, 'quantity': 0},
    {'name': 'Forbes', 'price': 9.99, 'quantity': 0},
    {'name': 'Wired', 'price': 4.99, 'quantity': 0},
    {'name': 'Harvard Business Review', 'price': 10.99, 'quantity': 0},
    {'name': 'Scientific American', 'price': 5.49, 'quantity': 0},
    {'name': 'Popular Science', 'price': 6.49, 'quantity': 0},
  ],
  'Stationery': [
    {'name': 'Notebook', 'price': 1.99, 'quantity': 0},
    {'name': 'Pen', 'price': 0.99, 'quantity': 0},
    {'name': 'Pencil', 'price': 0.49, 'quantity': 0},
    {'name': 'Highlighter', 'price': 1.29, 'quantity': 0},
    {'name': 'Sticky Notes', 'price': 2.49, 'quantity': 0},
    {'name': 'Paper Clips', 'price': 0.99, 'quantity': 0},
    {'name': 'Eraser', 'price': 0.69, 'quantity': 0},
    {'name': 'Folder', 'price': 1.49, 'quantity': 0},
    {'name': 'Tape', 'price': 1.79, 'quantity': 0},
    {'name': 'Ruler', 'price': 0.99, 'quantity': 0},
  ],
  'Crafts': [
    {'name': 'Paint Brushes', 'price': 5.99, 'quantity': 0},
    {'name': 'Canvas', 'price': 7.99, 'quantity': 0},
    {'name': 'Colored Pencils', 'price': 3.99, 'quantity': 0},
    {'name': 'Glue', 'price': 2.49, 'quantity': 0},
    {'name': 'Knitting Needles', 'price': 6.99, 'quantity': 0},
    {'name': 'Embroidery Thread', 'price': 4.99, 'quantity': 0},
    {'name': 'Craft Paper', 'price': 2.99, 'quantity': 0},
    {'name': 'Beads', 'price': 3.49, 'quantity': 0},
    {'name': 'Stickers', 'price': 1.99, 'quantity': 0},
    {'name': 'Sewing Kit', 'price': 12.99, 'quantity': 0},
  ],
  'Outdoor & Adventure': [
    {'name': 'Tent', 'price': 79.99, 'quantity': 0},
    {'name': 'Sleeping Bag', 'price': 39.99, 'quantity': 0},
    {'name': 'Camping Stove', 'price': 29.99, 'quantity': 0},
    {'name': 'Hiking Boots', 'price': 59.99, 'quantity': 0},
    {'name': 'Backpack', 'price': 49.99, 'quantity': 0},
    {'name': 'Compass', 'price': 12.99, 'quantity': 0},
    {'name': 'Flashlight', 'price': 9.99, 'quantity': 0},
    {'name': 'Binoculars', 'price': 24.99, 'quantity': 0},
    {'name': 'Water Bottle', 'price': 6.99, 'quantity': 0},
    {'name': 'Hiking Poles', 'price': 34.99, 'quantity': 0},
  ],
  'Watches': [
    {'name': 'Men\'s Watch', 'price': 49.99, 'quantity': 0},
    {'name': 'Women\'s Watch', 'price': 59.99, 'quantity': 0},
    {'name': 'Smartwatch', 'price': 199.99, 'quantity': 0},
    {'name': 'Leather Strap Watch', 'price': 89.99, 'quantity': 0},
    {'name': 'Sports Watch', 'price': 129.99, 'quantity': 0},
    {'name': 'Pocket Watch', 'price': 34.99, 'quantity': 0},
    {'name': 'Casual Watch', 'price': 24.99, 'quantity': 0},
    {'name': 'Luxury Watch', 'price': 399.99, 'quantity': 0},
    {'name': 'Digital Watch', 'price': 19.99, 'quantity': 0},
    {'name': 'Analog Watch', 'price': 39.99, 'quantity': 0},
  ],
  'Gifts': [
    {'name': 'Gift Card', 'price': 25.00, 'quantity': 0},
    {'name': 'Personalized Mug', 'price': 14.99, 'quantity': 0},
    {'name': 'Teddy Bear', 'price': 19.99, 'quantity': 0},
    {'name': 'Jewelry Box', 'price': 29.99, 'quantity': 0},
    {'name': 'Custom T-Shirt', 'price': 20.99, 'quantity': 0},
    {'name': 'Photo Frame', 'price': 9.99, 'quantity': 0},
    {'name': 'Birthday Balloon', 'price': 1.99, 'quantity': 0},
    {'name': 'Candles', 'price': 4.99, 'quantity': 0},
    {'name': 'Gift Basket', 'price': 49.99, 'quantity': 0},
    {'name': 'Customized Keychain', 'price': 7.99, 'quantity': 0},
  ],
};


  late List<Map<String, dynamic>> products;

  @override
  void initState() {
    super.initState();
    // Initialize the products list based on the selected category
    products = categoryProducts[widget.categoryTitle] ?? [];

    // Initialize controllers for each product
    for (var product in products) {
      product['controller'] = TextEditingController();
      product['controller'].text = product['quantity'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} '),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context); // Go back to home page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Product List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Product Name
                          Expanded(
                            flex: 2,
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Quantity Controller (- Button, Quantity Display, + Button)
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Less (-) Button
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      if (product['quantity'] > 0) {
                                        product['quantity']--;
                                        product['controller'].text =
                                            product['quantity'].toString();
                                      }
                                    });
                                  },
                                ),
                                // Quantity Display
                                Text(
                                  product['quantity'].toString(),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Add (+) Button
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  color: Colors.green,
                                  onPressed: () {
                                    setState(() {
                                      product['quantity']++;
                                      product['controller'].text =
                                          product['quantity'].toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Manual Quantity Input
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: product['controller'],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Qty',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  final newQuantity = int.tryParse(value) ?? 0;
                                  if (newQuantity >= 0) {
                                    product['quantity'] = newQuantity;
                                  } else {
                                    product['controller'].text =
                                        product['quantity'].toString();
                                  }
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
          // Footer
Container(
  padding: const EdgeInsets.all(10.0),
  color: Colors.teal[100], // Set background color
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround, // Space buttons evenly
    children: [
      // Buy Now Button
      ElevatedButton(
        onPressed: () {
          // Add your action for 'Buy Now' here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buy Now clicked')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Button color
        ),
        child: const Text('Buy Now'),
      ),
      // Add to Cart Button
      ElevatedButton(
        onPressed: () {
          // Add your action for 'Add to Cart' here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to Cart')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button color
        ),
        child: const Text('Add to Cart'),
      ),
    ],
  ),
),


        ],
      ),
    );
  }
}

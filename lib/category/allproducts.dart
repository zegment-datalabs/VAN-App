import 'package:flutter/material.dart';
class AllProducts extends StatelessWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All products'),
      ),
      body: const Center(
        child: Text('All products page'),
      ),
    );
  }
}

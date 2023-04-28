import 'package:flutter/material.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Store',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.teal.shade100.withOpacity(0.2),
      body: Container(
        child: const Text('My Store'),
      ),
    );
  }
}

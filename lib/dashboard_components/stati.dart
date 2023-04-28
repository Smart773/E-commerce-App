import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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

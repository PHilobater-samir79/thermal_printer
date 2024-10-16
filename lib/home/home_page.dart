import 'package:flutter/material.dart';
import 'package:test_printer/home/widgets/home_body_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter - Thermal Printer'),
        backgroundColor: Colors.redAccent,
      ),
      body: const HomeBodyView(),
    );
  }
}

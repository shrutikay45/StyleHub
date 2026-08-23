import 'package:flutter/material.dart';

class IronScreen extends StatelessWidget {
  const IronScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irons'),
      ),
      body: const Center(
        child: Text('Iron Products'),
      ),
    );
  }
}
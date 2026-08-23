import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),

      body: FutureBuilder<List<Product>>(
        future: ApiService.getProducts(),

        builder: (context, snapshot) {

          // 1. API is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading...'),
            );
          }

          // 2. API returned an error
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // 3. API successfully returned products
          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,

            itemBuilder: (context, index) {

              final product = products[index];

              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.category),
                trailing: Text('₹${product.price}'),
              );
            },
          );
        },
      ),
    );
  }
}
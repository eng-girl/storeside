import 'package:flutter/material.dart';
import '../../data/models/storeowner_product.dart';

class ProductDetailScreen extends StatelessWidget {
  final StoreOwnerProduct product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image carousel for product images
              product.images.isNotEmpty
                  ? SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.network(
                        product.images[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text('Image not available'));
                        },
                      ),
                    );
                  },
                ),
              )
                  : const Text('No images available', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(
                'Product Name: ${product.name}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Price: \$${product.price}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              Text('Description: ${product.description}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Material: ${product.material}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Category: ${product.category}', style: const TextStyle(fontSize: 18)),
              Text('Stock: ${product.stock}', style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
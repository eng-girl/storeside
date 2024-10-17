import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/auth_cubit.dart';
import '../../../bloc/cubit/storeownerproduct_cubit.dart';
import '../../../bloc/state/storeownerproduct_state.dart';
import '../../../data/models/storeowner_product.dart';
import '../../storeownernoproduct.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthCubit>(context).currentUser;

    // Fetch product details when the widget builds and user is not null
    if (user != null) {
      context.read<StoreOwnerProductCubit>().fetchProductByStoreOwner(user.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: BlocConsumer<StoreOwnerProductCubit, StoreOwnerProductState>(
        listener: (context, productState) {
          if (productState is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(productState.message)),
            );
          }
        },
        builder: (context, productState) {
          if (productState is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (productState is ProductLoaded) {
            final StoreOwnerProduct product = productState.product;
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Name: ${product.name}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // Display images (carousel or grid view)
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
                                  return const Text('Image not available', style: TextStyle(fontSize: 16));
                                },
                              ),
                            );
                          },
                        ),
                      )
                          : const Text('No images available', style: TextStyle(fontSize: 16)),
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
          } else if (productState is ProductError) {
            return Center(child: Text('Something went wrong: ${productState.message}', style: const TextStyle(fontSize: 18)));
          }
          // If no product data available, show the no product screen
          return StoreOwnerNoProduct();
        },
      ),
    );
  }
}

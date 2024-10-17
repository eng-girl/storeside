import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/auth_cubit.dart';
import '../../../bloc/cubit/storeownerproduct_cubit.dart';
import '../../../bloc/state/storeownerproduct_state.dart';
import '../../../data/models/storeowner_product.dart';
import '../../storeownernoproduct.dart';
import '../ProductDetailScreen.dart';

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
        title: const Text('Product List'),
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
            final List<StoreOwnerProduct> products = productState.productList;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final StoreOwnerProduct product = products[index];
                return ListTile(
                  leading: product.thumbnail != null
                      ? Image.network(
                    product.thumbnail!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  )
                      : const Icon(Icons.image_not_supported),
                  title: Text(product.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            );
          } else if (productState is ProductError) {
            // Display the no product screen if the error message indicates no products
            return StoreOwnerNoProduct();
          }
          // If no product data available, show the no product screen
          return StoreOwnerNoProduct();
        },
      ),
    );
  }
}
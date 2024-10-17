/*import 'package:flutter/material.dart';
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
            return Center(child: CircularProgressIndicator());
          } else if (productState is ProductLoaded) {
            final Product product = productState.product; // Get the loaded product information
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Product Name: ${product.name}', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 16),
                  Text('Price: \$${product.price}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 16),
                  Image.network(product.thumbnail), // Display thumbnail
                  SizedBox(height: 16),
                  Text('Description: ${product.description}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Material: ${product.material}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Category: ${product.category}', style: TextStyle(fontSize: 18)),
                  Text('Stock: ${product.stock}', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else if (productState is ProductError) {
            return Center(child: Text('Something went wrong: ${productState.message}', style: TextStyle(fontSize: 18)));
          }
          // If no product data available, show the no product screen
          return StoreOwnerNoProduct();
        },
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import '../../addstoreownerproduct.dart';

class StoreOwnerNoProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/No data-cuate.png', width: 300),
            const SizedBox(height: 8),
            const Text('متجرك خالي من المنتجات لنقم بتعبئته معا', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStoreOwnerProduct()),
                );
              },
              child: const Text('إضافة منتج جديد'), // Change button text to Arabic
            ),
          ],
        ),
      ),
    );
  }
}
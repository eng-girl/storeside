import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/auth_cubit.dart';
import '../../../bloc/cubit/store_cubit.dart';
import '../../../bloc/state/store_state.dart';
import '../../../data/models/store_model.dart';

// Import the StoreState class
class StorInfo extends StatelessWidget {
  const StorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthCubit>(context).currentUser;




    // Fetch store details when the widget builds and user is not null
    if (user != null) {
      context.read<StoreCubit>().fetchStore(user.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: BlocConsumer<StoreCubit, StoreState>(
        listener: (context, storeState) {
          if (storeState is StoreError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(storeState.message)),
            );
          }
        },
        builder: (context, storeState) {
          if (storeState is StoreLoading) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (storeState is StoreLoaded) {
            final Store store = storeState.store; // Get the loaded store information
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${user!.username}!', style: TextStyle(fontSize: 24)), // Use ! here
                  SizedBox(height: 16),
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Role: ${user.role}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text('Store Name: ${store.name}', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 16),
                  Image.network(store.image), // Display store image
                  SizedBox(height: 16),
                  Text('Bio: ${store.bio}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Contact Info: ${store.contactInfo}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Total Orders: ${store.totalOrders}', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return Center(child: Text('No store data available', style: TextStyle(fontSize: 18)));
        },
      ),
    );
  }
}
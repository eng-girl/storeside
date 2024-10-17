/*import 'package:flutter/material.dart';
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
}*/

// with design
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/auth_cubit.dart';
import '../../../bloc/cubit/store_cubit.dart';
import '../../../bloc/state/store_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/store_model.dart';
import '../../../widgets/transaction_item.dart';  // Import TransactionItem from widgets

class StorInfo extends StatelessWidget {
  const StorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthCubit>(context).currentUser;

    // Fetch store details when the widget builds and user is not null
    if (user != null) {
      context.read<StoreCubit>().fetchStore(user.id);
    }

    return Directionality(
      textDirection: TextDirection.rtl, // RTL layout
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(Icons.notifications, color: Theme.of(context).brightness ==
                    Brightness.dark
                    ? AppColors.white
                    : AppColors.black,),
                Spacer(),
              ],
            ),
          ),
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
              return Center(child: CircularProgressIndicator());
            } else if (storeState is StoreLoaded) {
              final Store store = storeState.store;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    store.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text(
                    store.name,
                    style: TextStyle(
                      color: Theme.of(context).brightness ==
            Brightness.dark
            ? AppColors.white
                : AppColors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  /*ElevatedButton(
                    onPressed: () {},
                    child: Text("متجري"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),*/
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الاحصائيات",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TransactionItem(
                          icon: Icons.credit_card,
                          label: "منتجات",
                          amount: "25",
                          color: Colors.red,
                        ),
                        Divider(),
                        TransactionItem(
                          icon: Icons.attach_money,
                          label: "الأرباح",
                          amount: "\$3000",
                          color: Colors.green,
                        ),
                        Divider(),
                        TransactionItem(
                          icon: Icons.receipt,
                          label: "الطليات",
                          amount: "20",
                          color: Colors.orange,
                        ),
                        Divider(),
                       /* TransactionItem(
                          icon: Icons.savings,
                          label: "Savings",
                          amount: "\$1000",
                          color: Colors.yellow,
                        ),*/
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: Text('No store data available', style: TextStyle(fontSize: 18)));
          },
        ),
      ),
    );
  }
}




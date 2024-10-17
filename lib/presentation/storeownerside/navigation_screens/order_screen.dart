import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/order_cubit.dart';
import '../../../bloc/state/order_state.dart';
import '../../../data/models/order.dart';
import '../../../bloc/cubit/auth_cubit.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthCubit>(context).currentUser;

    // Fetch orders when the widget builds and user is not null
    if (user != null) {
      context.read<OrderCubit>().fetchOrdersByUserId(user.id); // Use user ID
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, orderState) {
          if (orderState is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(orderState.message)),
            );
          }
        },
        builder: (context, orderState) {
          if (orderState is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (orderState is OrderLoaded) {
            final List<Order> orders = orderState.orderList;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text('Order ID: ${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Amount: \$${order.totalAmount}'),
                        Text('Status: ${order.status}'),
                        Text('Shipping Address: ${order.shippingAddress}'),
                        Text('Payment Method: ${order.paymentMethod}'),
                        Text('Placed At: ${order.placedAt.toLocal()}'),
                        const SizedBox(height: 5),
                        const Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...order.products.map((product) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('• ${product.product.name} (x${product.quantity}) - \$${product.product.price}'),
                          );
                        }).toList(),
                      ],
                    ),
                    onTap: () {
                      // Navigate to order detail screen if needed
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No orders found.'));
        },
      ),
    );
  }
}

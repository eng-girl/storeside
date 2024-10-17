import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/customer_cubit.dart';
import '../../../bloc/cubit/order_cubit.dart';
import '../../../bloc/state/customer_state.dart';
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

                // Fetch customer info for the current order
                context.read<CustomerCubit>().fetchCustomerById(order.customerId);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text('Order ID: ${order.id}'),
                    subtitle: BlocBuilder<CustomerCubit, CustomerState>(
                      builder: (context, customerState) {
                        String customerInfo = 'Loading customer info...';
                        if (customerState is CustomerLoaded) {
                          customerInfo = 'Customer Name: ${customerState.customer.name}\n'
                              'Customer Address: ${customerState.customer.address}';
                        } else if (customerState is CustomerError) {
                          customerInfo = customerState.message;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Amount: \$${order.totalAmount}'),
                            Text('Status: ${order.status}'),
                            Text('Shipping Address: ${order.shippingAddress}'),
                            Text('Payment Method: ${order.paymentMethod}'),
                            Text('Placed At: ${order.placedAt.toLocal()}'),
                            const SizedBox(height: 5),
                            Text(customerInfo), // Display customer info
                            const SizedBox(height: 5),
                            const Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...order.products.map((product) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Display product image
                                    Image.network(
                                      product.image,
                                      width: 50, // Set width for the image
                                      height: 50, // Set height for the image
                                      fit: BoxFit.cover, // Adjust image fit
                                    ),
                                    const SizedBox(width: 8), // Space between image and text
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('• ${product.product.name} (x${product.quantity}) - \$${product.product.price}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
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

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/order.dart';
import '../../../bloc/cubit/order_cubit.dart';
import '../core/theme/app_colors.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    // Fetch cached customer info
    final customer = context.read<OrderCubit>().getCustomer(order.customerId);

    Color statusColor;

    switch (order.status) {
      case 'قيد التنفيذ':
        statusColor = Colors.orange;
        break;
      case 'تم الإلغاء':
        statusColor = Colors.red;
        break;
      case 'تم التسليم':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [8, 4],
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.primary
          : AppColors.darkBackground,
      strokeWidth: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('رقم الطلب: ${order.id}', overflow: TextOverflow.ellipsis)),
                Row(
                  children: [
                    Icon(Icons.circle, color: statusColor, size: 10),
                    SizedBox(width: 5),
                    Text(order.status, style: TextStyle(color: statusColor)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('المبلغ الإجمالي: \$${order.totalAmount}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('عنوان الشحن: ${order.shippingAddress}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            if (customer != null) ...[
              Text('اسم العميل: ${customer.name}', style: TextStyle(color: Colors.grey)),
              Text('عنوان العميل: ${customer.address}', style: TextStyle(color: Colors.grey)),
            ] else ...[
              const Text('جارٍ تحميل معلومات العميل...', style: TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 10),
            const Text('المنتجات:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...order.products.map((product) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('• ${product.product.name} (x${product.quantity}) - \$${product.product.price}', overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
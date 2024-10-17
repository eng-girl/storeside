import 'package:bloc/bloc.dart';
import '../../data/models/order.dart';
import '../../data/repo/order_repo.dart';
import '../state/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository orderRepository;

  OrderCubit(this.orderRepository) : super(OrderInitial());

  Future<void> fetchOrdersByUserId(String userId) async {
    emit(OrderLoading());
    try {
      final List<Order> orders = await orderRepository.getOrdersByUserId(userId);
      if (orders.isNotEmpty) {
        emit(OrderLoaded(orders));
      } else {
        emit(OrderError('No orders available.'));
      }
    } catch (e) {
      emit(OrderError('Error: $e'));
    }
  }
}
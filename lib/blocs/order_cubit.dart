import 'order_state.dart';
import '../models/order.dart';
import '../data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/order_repository.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderCubit(ApiService apiService)
      : _orderRepository = OrderRepository(apiService),
        super(OrderInitial());

  Future<void> fetchAllOrders() async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getAllOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> fetchOrderById(int id) async {
    emit(OrderLoading());
    try {
      final order = await _orderRepository.getOrderById(id);
      emit(OrderLoaded(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> createOrder(OrderModel order) async {
    emit(OrderLoading());
    try {
      final createdOrder = await _orderRepository.createOrder(order);
      emit(OrderLoaded(createdOrder));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> updateOrder(int id, OrderModel order) async {
    emit(OrderLoading());
    try {
      final updatedOrder = await _orderRepository.updateOrder(id, order);
      emit(OrderLoaded(updatedOrder));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> deleteOrder(int id) async {
    emit(OrderLoading());
    try {
      await _orderRepository.deleteOrder(id);
      await fetchAllOrders();
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}

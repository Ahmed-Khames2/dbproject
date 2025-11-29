import 'order_item_state.dart';
import '../models/order_item.dart';
import '../data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/order_item_repository.dart';

class OrderItemCubit extends Cubit<OrderItemState> {
  final OrderItemRepository _orderItemRepository;

  OrderItemCubit(ApiService apiService)
      : _orderItemRepository = OrderItemRepository(apiService),
        super(OrderItemInitial());

  Future<void> fetchAllOrderItems() async {
    emit(OrderItemLoading());
    try {
      final orderItems = await _orderItemRepository.getAllOrderItems();
      emit(OrderItemsLoaded(orderItems));
    } catch (e) {
      emit(OrderItemError(e.toString()));
    }
  }

  Future<void> fetchOrderItemById(int id) async {
    emit(OrderItemLoading());
    try {
      final orderItem = await _orderItemRepository.getOrderItemById(id);
      emit(OrderItemLoaded(orderItem));
    } catch (e) {
      emit(OrderItemError(e.toString()));
    }
  }

  Future<void> createOrderItem(OrderItemModel orderItem) async {
    emit(OrderItemLoading());
    try {
      final createdOrderItem = await _orderItemRepository.createOrderItem(orderItem);
      emit(OrderItemLoaded(createdOrderItem));
    } catch (e) {
      emit(OrderItemError(e.toString()));
    }
  }

  Future<void> updateOrderItem(int id, OrderItemModel orderItem) async {
    emit(OrderItemLoading());
    try {
      final updatedOrderItem = await _orderItemRepository.updateOrderItem(id, orderItem);
      emit(OrderItemLoaded(updatedOrderItem));
    } catch (e) {
      emit(OrderItemError(e.toString()));
    }
  }

  Future<void> deleteOrderItem(int id) async {
    emit(OrderItemLoading());
    try {
      await _orderItemRepository.deleteOrderItem(id);
      await fetchAllOrderItems();
    } catch (e) {
      emit(OrderItemError(e.toString()));
    }
  }

  Future<void> fetchOrderItemsByOrderId(int orderId) async {
    emit(OrderItemLoading());
    try {
      final orderItems = await _orderItemRepository.getOrderItemsByOrderId(orderId);
      emit(OrderItemsLoaded(orderItems));
    } catch (e) {
      emit(OrderItemError(e.toString()));
    }
  }
}

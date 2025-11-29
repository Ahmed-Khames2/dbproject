import 'api_service.dart';
import 'package:dio/dio.dart';
import '../../models/order_item.dart';

class OrderItemApiService {
  final ApiService _apiService;

  OrderItemApiService(this._apiService);

  Future<List<OrderItemModel>> getAllOrderItems() async {
    try {
      final response = await _apiService.get('/order-items');
      final data = response.data as List;
      return data.map((json) => OrderItemModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch order items: $e');
    }
  }

  Future<OrderItemModel> getOrderItemById(int id) async {
    try {
      final response = await _apiService.get('/order-items/$id');
      return OrderItemModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch order item: $e');
    }
  }

  Future<OrderItemModel> createOrderItem(OrderItemModel orderItem) async {
    try {
      final response = await _apiService.post('/order-items', data: orderItem.toJson());
      return OrderItemModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create order item: $e');
    }
  }

  Future<OrderItemModel> updateOrderItem(int id, OrderItemModel orderItem) async {
    try {
      final response = await _apiService.put('/order-items/$id', data: orderItem.toJson());
      return OrderItemModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update order item: $e');
    }
  }

  Future<void> deleteOrderItem(int id) async {
    try {
      await _apiService.delete('/order-items/$id');
    } catch (e) {
      throw Exception('Failed to delete order item: $e');
    }
  }

  Future<List<OrderItemModel>> getOrderItemsByOrderId(int orderId) async {
    try {
      final response = await _apiService.get('/orders/$orderId/items');
      final data = response.data as List;
      return data.map((json) => OrderItemModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch order items for order $orderId: $e');
    }
  }
}

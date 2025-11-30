import 'api_service.dart';
import '../../models/order.dart';

class OrderApiService {
  final ApiService _apiService;

  OrderApiService(this._apiService);

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _apiService.get('/orders');
      final data = response.data as List;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<OrderModel> getOrderById(int id) async {
    try {
      final response = await _apiService.get('/orders/$id');
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final response = await _apiService.post('/orders', data: order.toJson());
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<OrderModel> updateOrder(int id, OrderModel order) async {
    try {
      final response = await _apiService.put(
        '/orders/$id',
        data: order.toJsonForUpdate(),
      );
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      await _apiService.delete('/orders/$id');
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
}

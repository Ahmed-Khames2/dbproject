import '../../models/order.dart';
import '../services/api_service.dart';
import '../services/order_api_service.dart';

class OrderRepository {
  final OrderApiService _orderApiService;

  OrderRepository(ApiService apiService) : _orderApiService = OrderApiService(apiService);

  Future<List<OrderModel>> getAllOrders() async {
    return await _orderApiService.getAllOrders();
  }

  Future<OrderModel> getOrderById(int id) async {
    return await _orderApiService.getOrderById(id);
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    return await _orderApiService.createOrder(order);
  }

  Future<OrderModel> updateOrder(int id, OrderModel order) async {
    return await _orderApiService.updateOrder(id, order);
  }

  Future<void> deleteOrder(int id) async {
    await _orderApiService.deleteOrder(id);
  }
}

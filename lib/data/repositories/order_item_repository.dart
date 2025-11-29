import '../../models/order_item.dart';
import '../services/api_service.dart';
import '../services/order_item_api_service.dart';

class OrderItemRepository {
  final OrderItemApiService _orderItemApiService;

  OrderItemRepository(ApiService apiService) : _orderItemApiService = OrderItemApiService(apiService);

  Future<List<OrderItemModel>> getAllOrderItems() async {
    return await _orderItemApiService.getAllOrderItems();
  }

  Future<OrderItemModel> getOrderItemById(int id) async {
    return await _orderItemApiService.getOrderItemById(id);
  }

  Future<OrderItemModel> createOrderItem(OrderItemModel orderItem) async {
    return await _orderItemApiService.createOrderItem(orderItem);
  }

  Future<OrderItemModel> updateOrderItem(int id, OrderItemModel orderItem) async {
    return await _orderItemApiService.updateOrderItem(id, orderItem);
  }

  Future<void> deleteOrderItem(int id) async {
    await _orderItemApiService.deleteOrderItem(id);
  }

  Future<List<OrderItemModel>> getOrderItemsByOrderId(int orderId) async {
    return await _orderItemApiService.getOrderItemsByOrderId(orderId);
  }
}

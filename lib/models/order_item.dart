class OrderItemModel {
  final int orderItemId;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;

  OrderItemModel({
    required this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['OrderItemID'],
      orderId: json['OrderID'],
      productId: json['ProductID'],
      quantity: json['Quantity'],
      unitPrice: json['UnitPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderItemID': orderItemId,
      'OrderID': orderId,
      'ProductID': productId,
      'Quantity': quantity,
      'UnitPrice': unitPrice,
    };
  }
}

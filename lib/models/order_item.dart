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
      orderItemId: json['OrderItemID'] as int,
      orderId: json['OrderID'] as int,
      productId: json['ProductID'] as int,
      quantity: json['Quantity'] as int,
      unitPrice: (json['UnitPrice'] as num?)?.toDouble() ?? 0.0,
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

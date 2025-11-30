class OrderModel {
  final int orderId;
  final int userId;
  final DateTime orderDate;
  final double totalAmount;
  final String status;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['OrderID'],
      userId: json['UserID'],
      orderDate: DateTime.parse(json['OrderDate']),
      totalAmount: json['TotalAmount'].toDouble(),
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderID': orderId,
      'UserID': userId,
      'OrderDate': orderDate.toIso8601String(),
      'TotalAmount': totalAmount,
      'Status': status,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'Status': status,
    };
  }

  OrderModel copyWith({
    int? orderId,
    int? userId,
    DateTime? orderDate,
    double? totalAmount,
    String? status,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}

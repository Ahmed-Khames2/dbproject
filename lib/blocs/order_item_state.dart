import '../models/order_item.dart';
import 'package:equatable/equatable.dart';

abstract class OrderItemState extends Equatable {
  const OrderItemState();

  @override
  List<Object?> get props => [];
}

class OrderItemInitial extends OrderItemState {}

class OrderItemLoading extends OrderItemState {}

class OrderItemsLoaded extends OrderItemState {
  final List<OrderItemModel> orderItems;

  const OrderItemsLoaded(this.orderItems);

  @override
  List<Object?> get props => [orderItems];
}

class OrderItemLoaded extends OrderItemState {
  final OrderItemModel orderItem;

  const OrderItemLoaded(this.orderItem);

  @override
  List<Object?> get props => [orderItem];
}

class OrderItemError extends OrderItemState {
  final String message;

  const OrderItemError(this.message);

  @override
  List<Object?> get props => [message];
}

import '../../models/order.dart';
import '../../models/product.dart';
import '../../data/dummy_data.dart';
import '../../models/order_item.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.order});

  final OrderModel order;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
  }

  List<OrderItemModel> getOrderItems(int orderId) {
    return dummyOrderItems.where((item) => item.orderId == orderId).toList();
  }

  void _saveStatus() {
    final index = dummyOrders.indexWhere(
      (o) => o.orderId == widget.order.orderId,
    );
    if (index != -1) {
      dummyOrders[index] = dummyOrders[index].copyWith(status: selectedStatus);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Status updated')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = getOrderItems(widget.order.orderId);
    double total = 0;
    for (var item in orderItems) {
      total += item.unitPrice * item.quantity;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.order.orderId}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${widget.order.orderId}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('User: ${getUserName(widget.order.userId)}'),
                    Text(
                      'Date: ${widget.order.orderDate.toString().substring(0, 10)}',
                    ),
                    Text(
                      'Total Amount: \$${widget.order.totalAmount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Status Dropdown
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
              ),
              items: ['Pending', 'Shipped', 'Delivered', 'Cancelled'].map((
                status,
              ) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Order Items List
            Text('Order Items', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: orderItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = orderItems[index];
                final product = dummyProducts.firstWhere(
                  (p) => p.productId == item.productId,
                  orElse: () => ProductModel(
                    productId: 0,
                    categoryId: 0,
                    name: 'Unknown Product',
                    price: 0,
                    stock: 0,
                  ),
                );
                return ListTile(
                  leading: const Icon(Icons.inventory),
                  title: Text('${item.quantity}x ${product.name}'),
                  subtitle: Text('Unit Price: \$${item.unitPrice}'),
                  trailing: Text(
                    '\$${(item.unitPrice * item.quantity).toStringAsFixed(2)}',
                  ),
                );
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveStatus,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Save Status'),
            ),
          ],
        ),
      ),
    );
  }
}

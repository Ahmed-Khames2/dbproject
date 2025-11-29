import '../../models/order.dart';
import 'order_details_page.dart';
import '../../data/dummy_data.dart';
import 'package:flutter/material.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  List<OrderModel> orders = dummyOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile: ListView
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = orders[index];
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(order: order),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: ${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('User: ${getUserName(order.userId)}'),
                        Text('Total: \$${order.totalAmount}'),
                        Text('Status: ${order.status}'),
                        Text('Date: ${order.orderDate.toString().substring(0, 10)}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            // Desktop: DataTable
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('OrderID')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('TotalAmount')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('OrderDate')),
                  ],
                  rows: orders.map((order) {
                    return DataRow(
                      onSelectChanged: (_) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(order: order),
                        ),
                      ),
                      cells: [
                        DataCell(Text(order.orderId.toString())),
                        DataCell(Text(getUserName(order.userId))),
                        DataCell(Text('\$${order.totalAmount}')),
                        DataCell(Text(order.status)),
                        DataCell(Text(order.orderDate.toString().substring(0, 10))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

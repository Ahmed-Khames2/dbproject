import '../../models/order.dart';
import '../../blocs/order_cubit.dart';
import 'package:flutter/material.dart';
import '../../widgets/form_elements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditOrderPage extends StatefulWidget {
  final OrderModel? order;

  const AddEditOrderPage({super.key, this.order});

  @override
  State<AddEditOrderPage> createState() => _AddEditOrderPageState();
}

class _AddEditOrderPageState extends State<AddEditOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedStatus = 'Pending';
  bool _isLoading = false;

  final List<String> _statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _selectedStatus = widget.order!.status;
    }
  }

  void _saveOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final order = OrderModel(
        orderId: widget.order?.orderId ?? 0,
        userId: widget.order?.userId ?? 0,
        orderDate: widget.order?.orderDate ?? DateTime.now(),
        totalAmount: widget.order?.totalAmount ?? 0.0,
        status: _selectedStatus,
      );

      try {
        if (widget.order == null) {
          // For now, orders are created automatically, so we might not need create functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order creation not implemented')),
          );
        } else {
          await context.read<OrderCubit>().updateOrder(widget.order!.orderId, order);
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order ${widget.order == null ? 'created' : 'updated'} successfully')),
        );
        // For orders, we typically want to go back after updating status
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Add Order' : 'Update Order Status'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (widget.order != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${widget.order!.orderId}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('User ID: ${widget.order!.userId}'),
                        Text('Order Date: ${widget.order!.orderDate.toString().substring(0, 10)}'),
                        Text(
                          'Total Amount: \$${widget.order!.totalAmount}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text('Current Status: ${widget.order!.status}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Order Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                validator: (value) => value == null ? 'Status is required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveOrder,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.order == null ? 'Create Order' : 'Update Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

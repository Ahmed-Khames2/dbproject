import '../../models/user.dart';
import '../../blocs/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key, required this.user});

  final UserModel user;

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = widget.user.copyWith(); // Assuming copyWith exists
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: user.fullName,
              decoration: const InputDecoration(labelText: 'Full Name'),
              onChanged: (value) => user = user.copyWith(fullName: value),
            ),
            TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) => user = user.copyWith(email: value),
            ),
            DropdownButtonFormField<String>(
              value: user.role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: ['admin', 'customer'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    user = user.copyWith(role: value);
                  });
                }
              },
            ),
            if (user.phone != null)
              TextFormField(
                initialValue: user.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                onChanged: (value) => user = user.copyWith(phone: value),
              ),
            if (user.address != null)
              TextFormField(
                initialValue: user.address,
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => user = user.copyWith(address: value),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<UserCubit>().updateUser(user.userId, user);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User saved successfully')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('حدث خطأ أثناء حفظ المستخدم')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

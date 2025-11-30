import '../../models/user.dart';
import '../../blocs/user_cubit.dart';
import 'package:flutter/material.dart';
import '../../widgets/form_elements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditUserPage extends StatefulWidget {
  final UserModel? user;

  const AddEditUserPage({super.key, this.user});

  @override
  State<AddEditUserPage> createState() => _AddEditUserPageState();
}

class _AddEditUserPageState extends State<AddEditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedRole = 'User';
  bool _isLoading = false;

  final List<String> _roles = ['Admin', 'User', 'Manager'];

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _fullNameController.text = widget.user!.fullName;
      _emailController.text = widget.user!.email;
      _phoneController.text = widget.user!.phone ?? '';
      _addressController.text = widget.user!.address ?? '';
      _selectedRole = widget.user!.role;
    }
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      // Validate password for new users
      if (widget.user == null && _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password is required for new users')),
        );
        return;
      }

      setState(() => _isLoading = true);
      final user = UserModel(
        userId: widget.user?.userId ?? 0,
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: widget.user != null && _passwordController.text.isEmpty
            ? widget.user!.password
            : _passwordController.text,
        role: _selectedRole,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        createdAt: widget.user?.createdAt ?? DateTime.now(),
      );

      try {
        if (widget.user == null) {
          await context.read<UserCubit>().createUser(user);
        } else {
          await context.read<UserCubit>().updateUser(widget.user!.userId, user);
        }
        if (!mounted) return;
        // Refresh the users list in the parent page
        context.read<UserCubit>().fetchAllUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User ${widget.user == null ? 'created' : 'updated'} successfully',
            ),
          ),
        );
        // Only pop for new users, stay on page for updates
        if (widget.user == null) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (!mounted) return;
        String errorMessage =
            'Failed to ${widget.user == null ? 'create' : 'update'} user';
        if (e.toString().contains('Email already exists') ||
            e.toString().contains('email')) {
          errorMessage = 'Email already exists or invalid';
        } else if (e.toString().contains('password')) {
          errorMessage = 'Password error - please check password requirements';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                label: 'Full Name',
                controller: _fullNameController,
                validator: (value) =>
                    value!.isEmpty ? 'Full name is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Email is required';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: widget.user == null
                    ? 'Password'
                    : 'Password (leave empty to keep current)',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (widget.user == null && (value == null || value.isEmpty)) {
                    return 'Password is required for new users';
                  }
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                validator: (value) => value == null ? 'Role is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone (Optional)',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Address (Optional)',
                controller: _addressController,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.user == null ? 'Create User' : 'Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

import 'user_details_page.dart';
import 'add_edit_user_page.dart';
import '../../blocs/user_cubit.dart';
import '../../blocs/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchAllUsers();
  }

  void _deleteUser(int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<UserCubit>().deleteUser(userId);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('User deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditUserPage()),
          );
          // Only refresh if navigation was successful (item was created)
          if (result == true || result == null) {
            try {
              await context.read<UserCubit>().fetchAllUsers();
            } catch (e) {
              // Silently handle refresh errors
              debugPrint('Failed to refresh users: $e');
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            final users = state.users;
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Mobile layout: ListView
                  return ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserDetailsPage(user: user),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID: ${user.userId}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text('Name: ${user.fullName}'),
                                        Text('Email: ${user.email}'),
                                        Text('Role: ${user.role}'),
                                        Text(
                                          'Created: ${user.createdAt.toString().substring(0, 10)}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddEditUserPage(user: user),
                                              ),
                                            )
                                            .then((_) {
                                              // Refresh the users list after editing (if widget is still mounted)
                                              if (mounted) {
                                                context
                                                    .read<UserCubit>()
                                                    .fetchAllUsers();
                                              }
                                            });
                                      } else if (value == 'delete') {
                                        _deleteUser(user.userId);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 18),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, size: 18),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Tablet/Desktop layout: DataTable
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('UserID')),
                          DataColumn(label: Text('FullName')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Role')),
                          DataColumn(label: Text('CreatedAt')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: users.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user.userId.toString())),
                              DataCell(Text(user.fullName)),
                              DataCell(Text(user.email)),
                              DataCell(Text(user.role)),
                              DataCell(
                                Text(
                                  user.createdAt.toString().substring(0, 10),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddEditUserPage(user: user),
                                              ),
                                            )
                                            .then((_) {
                                              // Refresh the users list after editing (if widget is still mounted)
                                              if (mounted) {
                                                context
                                                    .read<UserCubit>()
                                                    .fetchAllUsers();
                                              }
                                            });
                                      },
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteUser(user.userId),
                                      tooltip: 'Delete',
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

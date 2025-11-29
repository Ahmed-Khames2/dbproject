import '../../models/user.dart';
import 'user_details_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
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
                              Text('ID: ${user.userId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Name: ${user.fullName}'),
                              Text('Email: ${user.email}'),
                              Text('Role: ${user.role}'),
                              Text('Created: ${user.createdAt.toString().substring(0, 10)}'),
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
                        ],
                        rows: users.map((user) {
                          return DataRow(
                            onSelectChanged: (_) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(user: user),
                                ),
                              );
                            },
                            cells: [
                              DataCell(Text(user.userId.toString())),
                              DataCell(Text(user.fullName)),
                              DataCell(Text(user.email)),
                              DataCell(Text(user.role)),
                              DataCell(Text(user.createdAt.toString().substring(0, 10))),
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

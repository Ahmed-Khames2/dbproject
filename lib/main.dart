import 'core/app_theme.dart';
import 'blocs/user_cubit.dart';
import 'blocs/order_cubit.dart';
import 'blocs/product_cubit.dart';
import 'blocs/category_cubit.dart';
import 'blocs/order_item_cubit.dart';
import 'package:flutter/material.dart';
import 'data/services/api_service.dart';
import 'ui/users/manage_users_page.dart';
import 'ui/dashboard/admin_dashboard.dart';
import 'ui/orders/manage_orders_page.dart';
import 'ui/products/manage_products_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/categories/manage_categories_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit(apiService)),
        BlocProvider(create: (_) => ProductCubit(apiService)),
        BlocProvider(create: (_) => CategoryCubit(apiService)),
        BlocProvider(create: (_) => OrderCubit(apiService)),
        BlocProvider(create: (_) => OrderItemCubit(apiService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Management Dashboard',
        theme: appThemeData[AppTheme.light],
        darkTheme: appThemeData[AppTheme.dark],
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const AdminDashboard(),
          '/manage-users': (context) => const ManageUsersPage(),
          '/manage-products': (context) => const ManageProductsPage(),
          '/manage-orders': (context) => const ManageOrdersPage(),
          '/manage-categories': (context) => const ManageCategoriesPage(),
          // Add more routes later
        },
      ),
    );
  }
}

import '../models/user.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/order_item.dart';

// Dummy Users
final List<UserModel> dummyUsers = [
  UserModel(
    userId: 1,
    fullName: 'John Doe',
    email: 'john@example.com',
    password: 'password123',
    role: 'Admin',
    phone: '123456789',
    address: '123 Main St',
    createdAt: DateTime(2023, 10, 1),
  ),
  UserModel(
    userId: 2,
    fullName: 'Jane Smith',
    email: 'jane@example.com',
    password: 'password123',
    role: 'Customer',
    phone: '987654321',
    address: '456 Elm St',
    createdAt: DateTime(2023, 11, 15),
  ),
  UserModel(
    userId: 3,
    fullName: 'Bob Johnson',
    email: 'bob@example.com',
    password: 'password123',
    role: 'Customer',
    phone: '555555555',
    address: '789 Oak Ave',
    createdAt: DateTime(2023, 12, 5),
  ),
];

// Dummy Categories
final List<CategoryModel> dummyCategories = [
  CategoryModel(
    categoryId: 1,
    categoryName: 'Electronics',
    description: 'Electronic devices and accessories',
  ),
  CategoryModel(
    categoryId: 2,
    categoryName: 'Books',
    description: 'Books of all genres',
  ),
  CategoryModel(
    categoryId: 3,
    categoryName: 'Clothing',
    description: 'Apparel and fashion items',
  ),
];

// Dummy Products
final List<ProductModel> dummyProducts = [
  ProductModel(
    productId: 1,
    categoryId: 1,
    name: 'Laptop',
    description: 'High-performance laptop with 16GB RAM and 512GB SSD',
    price: 999.99,
    stock: 10,
    imageUrl: 'https://picsum.photos/seed/laptop123/400/300.jpg',
  ),
  ProductModel(
    productId: 2,
    categoryId: 1,
    name: 'Smartphone',
    description: 'Latest smartphone model with 5G connectivity',
    price: 699.99,
    stock: 20,
    imageUrl: 'https://picsum.photos/seed/phone456/400/300.jpg',
  ),
  ProductModel(
    productId: 3,
    categoryId: 2,
    name: 'Programming Book',
    description: 'Learn Dart programming from beginner to advanced',
    price: 49.99,
    stock: 50,
    imageUrl: 'https://picsum.photos/seed/book789/400/300.jpg',
  ),
  ProductModel(
    productId: 4,
    categoryId: 3,
    name: 'T-Shirt',
    description: 'Comfortable cotton t-shirt in various colors',
    price: 19.99,
    stock: 100,
    imageUrl: 'https://picsum.photos/seed/tshirt101/400/300.jpg',
  ),
  ProductModel(
    productId: 5,
    categoryId: 1,
    name: 'Wireless Headphones',
    description: 'Noise-cancelling Bluetooth headphones',
    price: 149.99,
    stock: 15,
    imageUrl: 'https://picsum.photos/seed/headphones202/400/300.jpg',
  ),
  ProductModel(
    productId: 6,
    categoryId: 3,
    name: 'Jeans',
    description: 'Slim fit denim jeans',
    price: 59.99,
    stock: 30,
    imageUrl: 'https://picsum.photos/seed/jeans303/400/300.jpg',
  ),
  ProductModel(
    productId: 7,
    categoryId: 2,
    name: 'Science Fiction Novel',
    description: 'Bestselling sci-fi adventure story',
    price: 24.99,
    stock: 25,
    imageUrl: 'https://picsum.photos/seed/scifi404/400/300.jpg',
  ),
  ProductModel(
    productId: 8,
    categoryId: 1,
    name: 'Tablet',
    description: '10-inch tablet with stylus support',
    price: 399.99,
    stock: 12,
    imageUrl: 'https://picsum.photos/seed/tablet505/400/300.jpg',
  ),
];

// Dummy Orders
final List<OrderModel> dummyOrders = [
  OrderModel(
    orderId: 1,
    userId: 1,
    orderDate: DateTime(2024, 1, 15),
    totalAmount: 1699.98,
    status: 'Pending',
  ),
  OrderModel(
    orderId: 2,
    userId: 2,
    orderDate: DateTime(2024, 2, 20),
    totalAmount: 49.99,
    status: 'Shipped',
  ),
  OrderModel(
    orderId: 3,
    userId: 3,
    orderDate: DateTime(2024, 3, 10),
    totalAmount: 719.98,
    status: 'Delivered',
  ),
];

// Dummy Order Items
final List<OrderItemModel> dummyOrderItems = [
  OrderItemModel(
    orderItemId: 1,
    orderId: 1,
    productId: 1,
    quantity: 1,
    unitPrice: 999.99,
  ),
  OrderItemModel(
    orderItemId: 2,
    orderId: 1,
    productId: 2,
    quantity: 1,
    unitPrice: 699.99,
  ),
  OrderItemModel(
    orderItemId: 3,
    orderId: 2,
    productId: 3,
    quantity: 1,
    unitPrice: 49.99,
  ),
  OrderItemModel(
    orderItemId: 4,
    orderId: 3,
    productId: 1,
    quantity: 1,
    unitPrice: 999.99,
  ),
  OrderItemModel(
    orderItemId: 5,
    orderId: 3,
    productId: 2,
    quantity: 1,
    unitPrice: 699.99,
  ),
  OrderItemModel(
    orderItemId: 6,
    orderId: 3,
    productId: 3,
    quantity: 1,
    unitPrice: 49.99,
  ),
];

// Helper functions to get related data
String getCategoryName(int categoryId) {
  final category = dummyCategories.firstWhere(
    (cat) => cat.categoryId == categoryId,
    orElse: () => CategoryModel(categoryId: 0, categoryName: 'Unknown'),
  );
  return category.categoryName;
}

String getUserName(int userId) {
  final user = dummyUsers.firstWhere(
    (u) => u.userId == userId,
    orElse: () => UserModel(
      userId: 0,
      fullName: 'Unknown User',
      email: '',
      password: '',
      role: '',
      createdAt: DateTime.now(),
    ),
  );
  return user.fullName;
}

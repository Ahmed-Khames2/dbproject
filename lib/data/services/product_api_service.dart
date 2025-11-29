import 'api_service.dart';
import 'package:dio/dio.dart';
import '../../models/product.dart';

class ProductApiService {
  final ApiService _apiService;

  ProductApiService(this._apiService);

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _apiService.get('/products');
      final data = response.data as List;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _apiService.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await _apiService.post('/products', data: product.toJsonForCreate());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    try {
      final response = await _apiService.put('/products/$id', data: product.toJson());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.delete('/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}

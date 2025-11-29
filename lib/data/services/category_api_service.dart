import 'api_service.dart';
import 'package:dio/dio.dart';
import '../../models/category.dart';

class CategoryApiService {
  final ApiService _apiService;

  CategoryApiService(this._apiService);

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _apiService.get('/categories');
      final data = response.data as List;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await _apiService.get('/categories/$id');
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final response = await _apiService.post('/categories', data: category.toJson());
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  Future<CategoryModel> updateCategory(int id, CategoryModel category) async {
    try {
      final response = await _apiService.put('/categories/$id', data: category.toJson());
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _apiService.delete('/categories/$id');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}

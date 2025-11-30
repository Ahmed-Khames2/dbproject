import 'api_service.dart';
import 'package:dio/dio.dart';
import '../../models/user.dart';

class UserApiService {
  final ApiService _apiService;

  UserApiService(this._apiService);

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiService.get('/users');
      final data = response.data as List;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<UserModel> getUserById(int id) async {
    try {
      final response = await _apiService.get('/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await _apiService.post('/users', data: user.toJsonForCreate());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel> updateUser(int id, UserModel user) async {
    try {
      final response = await _apiService.put('/users/$id', data: user.toJsonForUpdate());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _apiService.delete('/users/$id');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}

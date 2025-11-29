import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'https://piny-blistery-toni.ngrok-free.dev'; // Update this to your API base URL

  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }
}

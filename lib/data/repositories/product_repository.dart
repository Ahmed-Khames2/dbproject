import '../../models/product.dart';
import '../services/api_service.dart';
import '../services/product_api_service.dart';

class ProductRepository {
  final ProductApiService _productApiService;

  ProductRepository(ApiService apiService) : _productApiService = ProductApiService(apiService);

  Future<List<ProductModel>> getAllProducts() async {
    return await _productApiService.getAllProducts();
  }

  Future<ProductModel> getProductById(int id) async {
    return await _productApiService.getProductById(id);
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    return await _productApiService.createProduct(product);
  }

  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    return await _productApiService.updateProduct(id, product);
  }

  Future<void> deleteProduct(int id) async {
    await _productApiService.deleteProduct(id);
  }
}

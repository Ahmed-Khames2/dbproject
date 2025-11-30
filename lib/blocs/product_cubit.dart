import 'product_state.dart';
import '../models/product.dart';
import '../data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/product_repository.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit(ApiService apiService)
      : _productRepository = ProductRepository(apiService),
        super(ProductInitial());

  Future<void> fetchAllProducts() async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getAllProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> fetchProductById(int id) async {
    emit(ProductLoading());
    try {
      final product = await _productRepository.getProductById(id);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> createProduct(ProductModel product) async {
    emit(ProductLoading());
    try {
      final createdProduct = await _productRepository.createProduct(product);
      emit(ProductLoaded(createdProduct));
      // Don't auto-refresh here, let UI handle it
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> updateProduct(int id, ProductModel product) async {
    emit(ProductLoading());
    try {
      final updatedProduct = await _productRepository.updateProduct(id, product);
      emit(ProductLoaded(updatedProduct));
      await fetchAllProducts(); // Refresh the list
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> deleteProduct(int id) async {
    emit(ProductLoading());
    try {
      await _productRepository.deleteProduct(id);
      await fetchAllProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

import '../../models/category.dart';
import '../services/api_service.dart';
import '../services/category_api_service.dart';

class CategoryRepository {
  final CategoryApiService _categoryApiService;

  CategoryRepository(ApiService apiService) : _categoryApiService = CategoryApiService(apiService);

  Future<List<CategoryModel>> getAllCategories() async {
    final categories = await _categoryApiService.getAllCategories();
    final uniqueCategories = <int, CategoryModel>{};
    for (final category in categories) {
      uniqueCategories[category.categoryId] = category;
    }
    return uniqueCategories.values.toList();
  }

  Future<CategoryModel> getCategoryById(int id) async {
    return await _categoryApiService.getCategoryById(id);
  }

  Future<CategoryModel> createCategory(CategoryModel category) async {
    return await _categoryApiService.createCategory(category);
  }

  Future<CategoryModel> updateCategory(int id, CategoryModel category) async {
    return await _categoryApiService.updateCategory(id, category);
  }

  Future<void> deleteCategory(int id) async {
    await _categoryApiService.deleteCategory(id);
  }
}

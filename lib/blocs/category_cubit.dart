import 'category_state.dart';
import '../models/category.dart';
import '../data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/category_repository.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit(ApiService apiService)
      : _categoryRepository = CategoryRepository(apiService),
        super(CategoryInitial());

  Future<void> fetchAllCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.getAllCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> fetchCategoryById(int id) async {
    emit(CategoryLoading());
    try {
      final category = await _categoryRepository.getCategoryById(id);
      emit(CategoryLoaded(category));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> createCategory(CategoryModel category) async {
    emit(CategoryLoading());
    try {
      final createdCategory = await _categoryRepository.createCategory(category);
      emit(CategoryLoaded(createdCategory));
      await fetchAllCategories(); // Refresh the list
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> updateCategory(int id, CategoryModel category) async {
    emit(CategoryLoading());
    try {
      final updatedCategory = await _categoryRepository.updateCategory(id, category);
      emit(CategoryLoaded(updatedCategory));
      await fetchAllCategories(); // Refresh the list
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> deleteCategory(int id) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.deleteCategory(id);
      await fetchAllCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}

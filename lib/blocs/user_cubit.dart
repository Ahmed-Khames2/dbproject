import 'user_state.dart';
import '../models/user.dart';
import '../data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(ApiService apiService)
      : _userRepository = UserRepository(apiService),
        super(UserInitial());

  Future<void> fetchAllUsers() async {
    emit(UserLoading());
    try {
      final users = await _userRepository.getAllUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> fetchUserById(int id) async {
    emit(UserLoading());
    try {
      final user = await _userRepository.getUserById(id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> createUser(UserModel user) async {
    emit(UserLoading());
    try {
      final createdUser = await _userRepository.createUser(user);
      emit(UserLoaded(createdUser));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUser(int id, UserModel user) async {
    emit(UserLoading());
    try {
      final updatedUser = await _userRepository.updateUser(id, user);
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> deleteUser(int id) async {
    emit(UserLoading());
    try {
      await _userRepository.deleteUser(id);
      // After deletion, perhaps refetch all users
      await fetchAllUsers();
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}

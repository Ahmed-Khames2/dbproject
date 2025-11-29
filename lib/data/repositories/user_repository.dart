import '../../models/user.dart';
import '../services/api_service.dart';
import '../services/user_api_service.dart';

class UserRepository {
  final UserApiService _userApiService;

  UserRepository(ApiService apiService) : _userApiService = UserApiService(apiService);

  Future<List<UserModel>> getAllUsers() async {
    return await _userApiService.getAllUsers();
  }

  Future<UserModel> getUserById(int id) async {
    return await _userApiService.getUserById(id);
  }

  Future<UserModel> createUser(UserModel user) async {
    return await _userApiService.createUser(user);
  }

  Future<UserModel> updateUser(int id, UserModel user) async {
    return await _userApiService.updateUser(id, user);
  }

  Future<void> deleteUser(int id) async {
    await _userApiService.deleteUser(id);
  }
}

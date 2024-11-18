import 'dart:convert';
import '../models/user_model.dart';
import '../core/api_service.dart';
import '../core/storage_service.dart';

class AuthRepository {
  final ApiService apiService;
  final StorageService storageService;

  AuthRepository({
    required this.apiService,
    required this.storageService,
  });

  // Registro de usuário usando ApiService
  Future<UserModel> register(String name, String email, String password) async {
    final response = await apiService.post('register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Erro ao registrar: ${response.body}');
    }
  }

  // Login de usuário usando ApiService
  Future<UserModel> login(String email, String password) async {
    final response = await apiService.post('login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Erro ao fazer login: ${response.body}');
    }
  }

  // Logout usando ApiService e StorageService
  Future<void> logout() async {
    String? token = await storageService.getToken();
    final response = await apiService.postWithAuth('logout', token!, {});

    if (response.statusCode == 200) {
      await storageService.removeToken();
      print('Logout realizado com sucesso');
    } else {
      throw Exception('Erro ao fazer logout');
    }
  }

  // Salva o token no StorageService
  Future<void> saveToken(String token) async {
    await storageService.saveToken(token);
  }

  // Obtém o token do StorageService
  Future<String?> getToken() async {
    return await storageService.getToken();
  }
}

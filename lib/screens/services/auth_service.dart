import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthService {
  final AuthRepository authRepository;

  AuthService({required this.authRepository});

  // Lógica de registro com repositório
  Future<void> register(String name, String email, String password) async {
    UserModel user = await authRepository.register(name, email, password);
    await authRepository.saveToken(user.token);
    print('Usuário registrado e token armazenado: ${user.token}');
  }

  // Lógica de login com repositório
  Future<void> login(String email, String password) async {
    UserModel user = await authRepository.login(email, password);
    await authRepository.saveToken(user.token);
    print('Login realizado e token armazenado: ${user.token}');
  }

  // Lógica de logout com repositório
  Future<void> logout() async {
    await authRepository.logout();
    print('Logout realizado');
  }

  // Pega o token usando o repositório
  Future<String?> getToken() async {
    return await authRepository.getToken();
  }
}

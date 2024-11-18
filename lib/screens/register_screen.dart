import 'package:flutter/material.dart';
import 'package:ubeventos_app/core/api_service.dart';
import 'package:ubeventos_app/core/storage_service.dart';
import 'package:ubeventos_app/repositories/auth_repository.dart';
import 'package:ubeventos_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
    final AuthService authService = AuthService(
  authRepository: AuthRepository(
    apiService: ApiService(),  // Instância de ApiService
    storageService: StorageService()  // Instância de StorageService
  ),
);

  void _register() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final passwordConfirmation = _passwordConfirmationController.text;


    if (password != passwordConfirmation) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('As senhas não coincidem'),
      ));
      return;
    }


    try {
      await authService.register(name, email, password);
      // Navegar para a próxima tela, por exemplo, a tela de login
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Tratar erro de registro (exibir mensagem, etc.)
      print('Erro ao registrar: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao registrar: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 2, 65), // Cor roxa do Figma
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset(
                'assets/images/gatito.png', // Caminho para a imagem
                height: 150, 
              ),
                TextField(
                  controller: _nameController, // Associando ao controlador de nome
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Nome',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController, // Associando ao controlador de email
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController, // Associando ao controlador de senha
                  obscureText: true, // Oculta a senha
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordConfirmationController, // Associando ao controlador de confirmação de senha
                  obscureText: true, // Oculta a confirmação de senha
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Confirme sua senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register, // Chama a função de registro
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('REGISTRAR'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navegar de volta para a tela de login
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Já tem uma conta? Faça login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

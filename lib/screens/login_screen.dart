import 'package:flutter/material.dart';
import 'package:ubeventos_app/core/api_service.dart';
import 'package:ubeventos_app/core/storage_service.dart';
import 'package:ubeventos_app/repositories/auth_repository.dart';
import 'package:ubeventos_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService(
  authRepository: AuthRepository(
    apiService: ApiService(),  // Instância de ApiService
    storageService: StorageService()  // Instância de StorageService
  ),
);

 
  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Exibir mensagem de erro se algum campo estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, preencha todos os campos!'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      await authService.login(email, password);
      // Navegar para a próxima tela, por exemplo, a tela principal de produtos
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Tratar erro de login (exibir mensagem, etc.)
      print('Erro ao fazer login: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Senha Incorreta'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 2, 65), // Cor roxa do Figma
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Substituindo o texto pelo widget de imagem
              Image.asset(
                'assets/images/gatito.png', // Caminho para a imagem
                height: 150, // Ajustar o tamanho da imagem conforme necessário
              ),
              TextField(
                controller: _emailController, // Associando ao controlador de email
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor : Colors.white,
                  foregroundColor : Colors.purple,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ), // Chama a função de login
                child: const Text('LOGIN'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                                Navigator.pushNamed(context, '/register');
                                  },
                            child: const Text('Registre-se'),
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




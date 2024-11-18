import 'package:flutter/material.dart';
import 'package:ubeventos_app/screens/home_screen.dart';
import 'package:ubeventos_app/screens/pedido_screen.dart';
import 'package:ubeventos_app/screens/register_screen.dart';
import 'package:ubeventos_app/screens/venda_screen.dart';
import 'screens/login_screen.dart';
import 'screens/produto_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      initialRoute: '/login', // A rota inicial é a tela de login
      routes: {
        '/login': (context) => const LoginScreen(),       // Rota para a tela de login
        '/produtos': (context) => const ProductScreen(),   // Rota para a tela de produtos
        '/vendas': (context) => VendaScreen(), 
        '/pedidos': (context) => PedidoScreen(), 
        '/register': (context) => const RegisterScreen(), 
        '/home': (context) => HomeScreen(), 
      },
    );
  }
}

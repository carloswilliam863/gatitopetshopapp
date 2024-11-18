import 'package:flutter/material.dart';
import 'package:ubeventos_app/screens/home_screen.dart';
import 'package:ubeventos_app/screens/pedido_screen.dart';
import 'package:ubeventos_app/screens/venda_screen.dart';
import 'package:ubeventos_app/screens/produto_screen.dart'; // Suponha que você tenha uma tela de produtos
import 'package:ubeventos_app/services/auth_service.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final AuthService authService;

  const BaseScreen({super.key, required this.child, required this.selectedIndex, required this.authService});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProductScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VendaScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PedidoScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definindo o título com base no índice selecionado
    String title;
    switch (selectedIndex) {
      case 0:
        title = 'HOME';
        break;
      case 1:
        title = 'PRODUTOS';
        break;
      case 2:
        title = 'VENDAS';
        break;
      case 3:
        title = 'PEDIDOS';
        break;
      default:
        title = 'APP';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8B3E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C1D63),
        title: Row(
          children: [
            Image.asset(
              'assets/images/gatitologo.png',
              width: 100,
            ),
            const SizedBox(width: 30),
            Text(
              title, // Usando o título dinâmico
              style: const TextStyle(fontFamily: 'RebeltonBold', fontSize: 25, color: Colors.white),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.white,
              onPressed: () async {
                await authService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF4C1D63),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.white),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            label: 'Vendas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory, color: Colors.white),
            label: 'Pedidos',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

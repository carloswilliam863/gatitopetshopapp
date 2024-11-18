import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ubeventos_app/core/api_service.dart';
import 'package:ubeventos_app/core/storage_service.dart';
import 'package:ubeventos_app/repositories/auth_repository.dart';
import 'package:ubeventos_app/screens/pedido_screen.dart';
import 'package:ubeventos_app/screens/produto_screen.dart';
import 'package:ubeventos_app/screens/venda_screen.dart';
import 'package:ubeventos_app/services/auth_service.dart';
import 'package:ubeventos_app/services/home_service.dart';
import 'package:ubeventos_app/screens/base_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? marcas;
  Map<String, dynamic>? categorias;
  List<String>? maiorOferta;
  final HomeService homeService = HomeService(); // Adicione esta linha
  final AuthService authService = AuthService(
  authRepository: AuthRepository(
    apiService: ApiService(),  // Instância de ApiService
    storageService: StorageService()  // Instância de StorageService
  ),
);

bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      final marcasResponse = await homeService.fetchMarcas(); // Atualize aqui
      final categoriasResponse = await homeService.fetchCategorias(); // Atualize aqui
      final ofertasResponse = await homeService.fetchMaiorOferta(); // Atualize aqui

      setState(() {
        marcas = marcasResponse;
        categorias = categoriasResponse;
        maiorOferta = ofertasResponse;
         isLoading = false;
      });
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os dados da home')),
      );
       setState(() {
        isLoading = false; // Defina como falso em caso de erro também
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        selectedIndex: 0,
        authService: authService, 
        child:  isLoading
          ? Center(child: CircularProgressIndicator()) // Ícone de carregamento
          : Padding(
                padding: const EdgeInsets.all(16.0),
                   child: SingleChildScrollView( // Adicione o SingleChildScrollView
                child: Column(
                  children: [
                    // Primeiro Card: Marcas
                    Card(
                      color: const Color(0xFF9E58B8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'MARCAS',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'RebeltonBold'),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Gatitos'),
                                    Text(marcas?['gatitos']?.toString() ?? '0', style: TextStyle(fontSize: 24)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Cachorritos'),
                                    Text(marcas?['cachorritos']?.toString() ?? '0', style: TextStyle(fontSize: 24)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Segundo Card: Categorias
                    Card(
                      color: const Color(0xFF9E58B8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'CATEGORIAS',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'RebeltonBold'),
                            ),
                            SizedBox(height: 8),
                            Column(
                              children: categorias!.entries.map((entry) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key),
                                    Text(entry.value.toString(), style: TextStyle(fontSize: 16)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Terceiro Card: Maior Oferta
                    Card(
                      color: const Color(0xFF9E58B8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'MAIOR OFERTA',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'RebeltonBold'),
                            ),
                            SizedBox(height: 8),
                            Column(
                              children: maiorOferta!.map((produto) {
                                return Text(produto, style: TextStyle(fontSize: 16));
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
    
}

}

import 'package:flutter/material.dart';
import 'package:ubeventos_app/repositories/auth_repository.dart';
import 'package:ubeventos_app/screens/base_screen.dart';
import 'package:ubeventos_app/services/auth_service.dart';
import 'package:ubeventos_app/services/product_service.dart';
import 'package:ubeventos_app/core/storage_service.dart';
import 'package:ubeventos_app/core/api_service.dart';
import '../models/product_model.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

   late final ApiService _apiService; // Declare ApiService
  late final StorageService _storageService; // Declare StorageService
  late final ProductService _productService;
  List<Product> _products = [];
  final AuthService authService = AuthService(
  authRepository: AuthRepository(
    apiService: ApiService(),  // Instância de ApiService
    storageService: StorageService()  // Instância de StorageService
  ),
);
 

  @override
  void initState() {
    super.initState();
     _apiService = ApiService(); // Ou outra forma de inicialização
    _storageService = StorageService(); // Ou outra forma de inicialização
     _productService = ProductService(_apiService, _storageService);
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _productService.fetchProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: 1,
      authService: authService, 
      child: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          var product = _products[index];
          return Card(
            color: const Color(0xFFB28FC5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  product.imagem != null
                      ? Image.network(
                          product.imagem,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Erro ao carregar imagem: $error');
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image),
                            );
                          },
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.nome ?? 'Nome indisponível',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          'Categoria: ${product.categoria ?? 'Indisponível'}',
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          'Marca: ${product.marca ?? 'Indisponível'}',
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          'Preço: R\$ ${product.preco?.toStringAsFixed(2).replaceAll('.', ',') ?? 'Indisponível'}',
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      product.quantidadeEmEstoque.toString() ?? 'Indisponível',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

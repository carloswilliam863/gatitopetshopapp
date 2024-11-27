import 'package:flutter/material.dart';
import 'package:ubeventos_app/core/api_service.dart';
import 'package:ubeventos_app/core/storage_service.dart';
import 'package:ubeventos_app/repositories/auth_repository.dart';
import 'package:ubeventos_app/screens/base_screen.dart';
import 'package:ubeventos_app/screens/home_screen.dart';
import 'package:ubeventos_app/screens/produto_screen.dart';
import 'package:ubeventos_app/screens/venda_screen.dart';
import 'package:ubeventos_app/services/auth_service.dart';
import 'package:ubeventos_app/services/pedido_service.dart';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  _PedidoScreenState createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  final PedidoService _pedidoService = PedidoService();
  final AuthService authService = AuthService(
  authRepository: AuthRepository(
    apiService: ApiService(),  // Instância de ApiService
    storageService: StorageService()  // Instância de StorageService
  ),
);


  List<DropdownMenuItem<int>> produtosDropdown = [];
  List<Map<String, dynamic>> produtosSelecionados = [];
  int quantidade = 1;
  String? marcaSelecionada; // Variável para armazenar a marca do produto

   



  @override
  void initState() {
    super.initState();
    carregarProdutos();
    adicionarProduto(); // Adiciona automaticamente um produto ao carregar a página
  }

  // Carregar a lista de produtos e montar o Dropdown
  void carregarProdutos() async {
    try {
      List<dynamic> produtos = await _pedidoService.fetchProdutos();
      setState(() {
        produtosDropdown = produtos.map((produto) {
          return DropdownMenuItem<int>(
            value: produto['id'],
            child: Text(produto['nome']),
          );
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar produtos: $e')),
      );
    }
  }

  void atualizarProduto(int index, int? produtoId) async {
  if (produtoId != null) {
    try {
      // Obter o produto com base no ID selecionado
      var produtoEncontrado = await _pedidoService.getProdutoPorId(produtoId);

      setState(() {
        produtosSelecionados[index]['produto_id'] = produtoId;
        marcaSelecionada = produtoEncontrado['marca']; // Atualiza a marca
      });
    } catch (e) {
      print('Erro ao buscar produto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao buscar detalhes do produto.')),
      );
    }
  } else {
    setState(() {
      produtosSelecionados[index]['produto_id'] = null;
      marcaSelecionada = null; // Reseta a marca se nenhum produto for selecionado
    });
  }
}


  // Adicionar um novo produto ao pedido (somente 1 produto será adicionado)
  void adicionarProduto() {
    setState(() {
      produtosSelecionados.add({
        'produto_id': null,
        'quantidade': 1,
      });
    });
  }

  // Confirmar a venda e atualizar o estoque de cada produto selecionado
  void confirmarPedido() async {
    try {
      for (var produto in produtosSelecionados) {
        if (produto['produto_id'] != null) {
          int produtoId = produto['produto_id'];
          int novaQuantidade = produto['quantidade'];
          await _pedidoService.atualizarEstoqueProduto(produtoId, novaQuantidade);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido realizado com sucesso! Estoque atualizado.')),
      );

      // Após confirmar o pedido, limpa o produto selecionado e adiciona um novo
      setState(() {
        produtosSelecionados.clear();
        adicionarProduto(); // Adiciona um novo produto para seleção
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar estoque: $e')),
      );
    }
  }

 @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: 3,
      authService: authService, 
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: produtosSelecionados.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Produto Dropdown
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF9E58B8), // Roxo claro
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              dropdownColor: const Color(0xFF9E58B8),
                              value: produtosSelecionados[index]['produto_id'],
                              items: produtosDropdown,
                              onChanged: (value) {
                                atualizarProduto(index, value);
                              },
                              hint: const Text(
                                'PRODUTO(S)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo Marca
                      Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9E58B8), // Roxo claro
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          marcaSelecionada ?? 'Marca',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Quantidade
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9E58B8), // Roxo mais claro
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: TextFormField(
                            initialValue: produtosSelecionados[index]
                                    ['quantidade']
                                .toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'QUANTIDADE',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                              filled: true,
                              fillColor: Color(0xFF9E58B8),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                produtosSelecionados[index]['quantidade'] =
                                    int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            // Botão Confirmar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9D9D9), // Botão cinza claro
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: confirmarPedido,
              child: const Text(
                'CONFIRMAR PEDIDO',
                style: TextStyle(
                  color: Color(0xFF4C1D63),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      );
  }
}

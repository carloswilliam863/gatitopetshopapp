import 'package:flutter/material.dart';
import 'package:ubeventos_app/core/api_service.dart';
import 'package:ubeventos_app/core/storage_service.dart';
import 'package:ubeventos_app/repositories/auth_repository.dart';
import 'package:ubeventos_app/screens/home_screen.dart';
import 'package:ubeventos_app/screens/pedido_screen.dart';
import 'package:ubeventos_app/screens/produto_screen.dart';
import 'package:ubeventos_app/services/auth_service.dart';
import 'package:ubeventos_app/services/venda_service.dart';
import 'package:ubeventos_app/screens/base_screen.dart';

class VendaScreen extends StatefulWidget {
  @override
  _VendaScreenState createState() => _VendaScreenState();
}

class _VendaScreenState extends State<VendaScreen> {
  final VendaService vendaService = VendaService();
  List<DropdownMenuItem<int>> clientesDropdown = [];
  List<DropdownMenuItem<int>> produtosDropdown = [];
  List<Map<String, dynamic>> produtosSelecionados = [];
    final AuthService authService = AuthService(
  authRepository: AuthRepository(
    apiService: ApiService(),  // Instância de ApiService
    storageService: StorageService()  // Instância de StorageService
  ),
);

  int? clienteSelecionado;
  int? produtoSelecionado;
  int quantidade = 1;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    carregarClientes();
    carregarProdutos();
    adicionarProduto();
  }

  void carregarClientes() async {
    List<dynamic> clientes = await vendaService.fetchClientes();
    setState(() {
      clientesDropdown = clientes.map((cliente) {
        return DropdownMenuItem<int>(
          value: cliente['id'],
          child: Text(cliente['nome']),
        );
      }).toList();
    });
  }

  void carregarProdutos() async {
    List<dynamic> produtos = await vendaService.fetchProdutos();
    setState(() {
      produtosDropdown = produtos.map((produto) {
        return DropdownMenuItem<int>(
          value: produto['id'],
          child: Text(produto['nome']),
        );
      }).toList();
    });
  }

  void adicionarProduto() {
    setState(() {
      produtosSelecionados.add({
        'produto_id': null,
        'quantidade': 1,
      });
    });
  }

  void removerProduto(int index) {
    setState(() {
      produtosSelecionados.removeAt(index);
    });
  }

  void atualizarProduto(int index, int? produtoId, int quantidade) {
    setState(() {
      produtosSelecionados[index]['produto_id'] = produtoId;
      produtosSelecionados[index]['quantidade'] = quantidade;
    });
  }

  void confirmarVenda() async {
    if (clienteSelecionado == null || produtosSelecionados.isEmpty) {
      // Adicionar validação se necessário
      return;
    }

    try {
      for (var produto in produtosSelecionados) {
        if (produto['produto_id'] != null) {
          int produtoId = produto['produto_id'];
          int novaQuantidade = produto['quantidade'];
          await vendaService.atualizarEstoqueProduto(produtoId, novaQuantidade);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Venda realizada com sucesso! Estoque atualizado.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar estoque: $e')),
      );
    }
  }


@override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: 2,
      authService: authService, 
        child: Column(
          children: [
            // Cliente Dropdown
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF9E58B8), // Roxo mais claro para os campos
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    dropdownColor: Color(0xFF9E58B8),
                    value: clienteSelecionado,
                    items: clientesDropdown,
                    onChanged: (value) {
                      setState(() {
                        clienteSelecionado = value;
                      });
                    },
                    hint: Text(
                      'CLIENTE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Produto(s) e quantidade
            Expanded(
  child: ListView.builder(
    itemCount: produtosSelecionados.length,
    itemBuilder: (context, index) {
      return Column(
        children: [
          Container(
            width: 400,
            decoration: BoxDecoration(
              color: Color(0xFF9E58B8), // Roxo mais claro para os campos
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  // Produto Dropdown
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      dropdownColor: Color(0xFF9E58B8),
                      value: produtosSelecionados[index]['produto_id'],
                      items: produtosDropdown,
                      onChanged: (value) {
                        atualizarProduto(index, value, produtosSelecionados[index]['quantidade']);
                      },
                      hint: Text(
                        'PRODUTO(S)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10), // Espaço entre o dropdown e o campo de quantidade
                  
                  // Campo de Quantidade
                  TextFormField(
                    initialValue: produtosSelecionados[index]['quantidade'].toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
                      int quantidade = int.tryParse(value) ?? 1;
                      atualizarProduto(index, produtosSelecionados[index]['produto_id'], quantidade);
                    },
                  ),
                  SizedBox(height: 10), // Espaço entre o campo de quantidade e o botão de remover

                  // Botão de remover produto
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.white),
                      onPressed: () => removerProduto(index),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10), // Espaçamento entre os produtos
        ],
      );
    },
  ),
),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD9D9D9), // Botão cinza
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: adicionarProduto,
              child: Text(
                'ADICIONAR PRODUTOS',
                style: TextStyle(
                  color: Color(0xFF4C1D63),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD9D9D9), // Botão cinza claro para confirmar
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: confirmarVenda,
              child: Text(
                'CONFIRMAR VENDA',
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
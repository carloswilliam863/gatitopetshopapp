import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubeventos_app/core/api_service.dart';
import 'package:ubeventos_app/core/storage_service.dart';
import 'package:ubeventos_app/models/product_model.dart';
import '../utils/url.dart';


class PedidoService {
  final String fullUrl = urlBase;

  // Função para obter o token armazenado no SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

   // Buscar produtos do banco de dados
Future<List<dynamic>> fetchProdutos() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse('$fullUrl/products'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Retorna a lista de produtos
    return List<dynamic>.from(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Erro ao carregar produtos');
  }
}


 // Função para buscar um produto específico pelo ID
  Future<Map<String, dynamic>> getProdutoPorId(int produtoId) async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$fullUrl/products/$produtoId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final produto = jsonDecode(response.body);
      return produto; // Retorna os detalhes do produto (incluindo marca)
    } else {
      print('Erro: ${response.statusCode} - ${response.body}');
      throw Exception('Erro ao buscar detalhes do produto');
    }
  }

Future<void> atualizarEstoqueProduto(int produtoId, int quantidadeVendida) async {
  String? token = await getToken();

  // Faz uma requisição GET para obter o estoque atual
  final getResponse = await http.get(
    Uri.parse('$fullUrl/products/$produtoId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (getResponse.statusCode != 200) {
    throw Exception('Erro ao buscar estoque atual');
  }

  // Obtenha o valor do estoque atual
  final produto = jsonDecode(getResponse.body);
  int estoqueAtual = produto['quantidadeEmEstoque'];

  // Subtraia a quantidade vendida do estoque atual
  int novaQuantidade = estoqueAtual + quantidadeVendida;


  // Atualiza o estoque com a nova quantidade
  final patchResponse = await http.patch(
    Uri.parse('$fullUrl/products/$produtoId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'quantidadeEmEstoque': novaQuantidade}),
  );

  if (patchResponse.statusCode != 200) {
    throw Exception('Erro ao atualizar estoque');
  }
}
}
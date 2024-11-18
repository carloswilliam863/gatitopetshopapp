import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/url.dart';


class VendaService {
  final String fullUrl = urlBase;

  // Função para obter o token armazenado no SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Buscar clientes do banco de dados
  Future<List<dynamic>> fetchClientes() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$fullUrl/clientes'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao carregar clientes');
    }
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


  
//Atualizar quantidade em Estoque
Future<void> atualizarEstoqueProduto(int produtoId, int quantidadeVendida) async {
    String? token = await getToken();

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
    int novaQuantidade = estoqueAtual - quantidadeVendida;

    if (novaQuantidade < 0) {
      throw Exception('Quantidade em estoque insuficiente');
    }

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
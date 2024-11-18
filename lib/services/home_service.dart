import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/url.dart';


class HomeService {
  final String fullUrl = '$urlBase/products';


  // Função para obter o token armazenado no SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> fetchMarcas() async {
     String? token = await getToken();
    final response = await http.get(Uri.parse('$fullUrl/count-by-brand'),
    headers: {
      'Authorization': 'Bearer $token',
    },);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao carregar marcas');
    }
  }

  Future<Map<String, dynamic>> fetchCategorias() async {
    String? token = await getToken();
    final response = await http.get(Uri.parse('$fullUrl/count-by-category'), 
        headers: {
        'Authorization': 'Bearer $token',
    },);
    if (response.statusCode == 200) {
      List<dynamic> categoriasList = jsonDecode(response.body);
      return {
        for (var item in categoriasList)
          item['categoria']: item['total'],
      };
    } else {
      throw Exception('Erro ao carregar categorias');
    }
  }

  Future<List<String>> fetchMaiorOferta() async {
    String? token = await getToken();
    final response = await http.get(Uri.parse('$fullUrl/top-quantities'), 
        headers: {
        'Authorization': 'Bearer $token',
    },);
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body)['produtos']);
    } else {
      throw Exception('Erro ao carregar maior oferta');
    }
  }
}

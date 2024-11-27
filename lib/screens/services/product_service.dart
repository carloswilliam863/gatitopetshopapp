import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/url.dart';
import '../models/product_model.dart';
import '../core/api_service.dart';
import '../core/storage_service.dart';

class ProductService {
  final ApiService apiService;
  final StorageService storageService;
  final String fullUrl = '$urlBase/products';

  ProductService(this.apiService, this.storageService);

  // Obter token do SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Listar todos os produtos
  Future<List<Product>> fetchProducts() async {
    String? token = await storageService.getToken();
    
    if (token == null) {
      throw Exception('Token não encontrado. O usuário pode não estar autenticado.');
    }

    final response = await apiService.get('products', headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      List<dynamic> productsData = responseData['data'] ?? [];
      
      // Converter cada item de JSON para uma instância de Product
      return productsData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar produtos: ${response.body}');
    }
  }
}

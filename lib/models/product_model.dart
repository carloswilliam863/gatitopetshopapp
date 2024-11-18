// product_model.dart
class Product {
  final String nome;
  final String categoria;
  final double preco;
  final String marca;
  final int quantidadeEmEstoque;
  final String imagem;

  var id;

  Product({
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.marca,
    required this.quantidadeEmEstoque,
    required this.imagem,
  });

  // Método para converter JSON em uma instância de Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
            preco: (json['preco'] is String) ? double.parse(json['preco']) : (json['preco'] ?? 0.0).toDouble(),
      marca: json['marca'] ?? '',
      quantidadeEmEstoque: json['quantidadeEmEstoque'] ?? 0,
      imagem: json['imagem'] ?? '',
    );
  }

  // Método para converter uma instância de Product em JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'categoria': categoria,
      'preco': preco,
      'marca': marca,
      'quantidadeEmEstoque': quantidadeEmEstoque,
      'imagem': imagem,
    };
  }
}

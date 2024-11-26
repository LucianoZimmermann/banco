// Classe que representa um investimento
class Investimento {
  final String id;
  final String nome;
  final String descricao;
  final double precoAtual;
  final String tipoMoeda;
  final double valorMoeda;

  Investimento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.precoAtual,
    required this.tipoMoeda,
    required this.valorMoeda,
  });

  // Método que converte o objeto Investimento em um mapa para armazenamento no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Adiciona o ID ao mapa
      'nome': nome, // Adiciona o nome ao mapa
      'descricao': descricao, // Adiciona a descrição ao mapa
      'tipoMoeda': tipoMoeda, // Adiciona o tipo da moeda ao mapa
      'valorMoeda': valorMoeda, // Adiciona o valor da moeda ao mapa
      'precoAtual': precoAtual, // Adiciona o preço atual ao mapa
    };
  }

  // Método de fábrica que cria uma instância de Investimento a partir de um mapa
  factory Investimento.fromFirestore(Map<String, dynamic> data) {
    return Investimento(
      id: data['id'] ?? '',
      nome: data['nome'] ?? '',
      descricao: data['descricao'] ?? '',
      precoAtual: (data['precoAtual'] ?? 0).toDouble(),
      tipoMoeda: data['tipoMoeda'] ?? '',
      valorMoeda: (data['valorMoeda'] ?? 0).toDouble(),
    );
  }
}
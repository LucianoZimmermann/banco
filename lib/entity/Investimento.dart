// Classe que representa um investimento
class Investimento {
  // Propriedades do investimento
  String id; // Identificador único do investimento
  String nome; // Nome do investimento
  String descricao; // Descrição do investimento
  String tipoMoeda; // Tipo da moeda do investimento (ex: "USD", "BRL")
  double valorMoeda; // Valor da moeda investida
  double precoAtual; // Preço atual do ativo

  // Construtor da classe, que inicializa as propriedades do investimento
  Investimento({
    required this.id, // ID do investimento (obrigatório)
    required this.nome, // Nome do investimento (obrigatório)
    required this.descricao, // Descrição do investimento (obrigatório)
    required this.tipoMoeda, // Tipo da moeda (obrigatório)
    required this.valorMoeda, // Valor da moeda (obrigatório)
    required this.precoAtual, // Preço atual (obrigatório)
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
  factory Investimento.fromMap(Map<String, dynamic> map, String id) {
    return Investimento(
      id: id, // Passa o ID recebido
      nome: map['nome'], // Obtém o nome do mapa
      descricao: map['descricao'], // Obtém a descrição do mapa
      tipoMoeda: map['tipoMoeda'], // Obtém o tipo da moeda do mapa
      valorMoeda: map['valorMoeda'], // Obtém o valor da moeda do mapa
      precoAtual: map['precoAtual'], // Obtém o preço atual do mapa
    );
  }
}
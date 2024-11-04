class Investimento {
  String id;
  String nome;
  String descricao;
  String tipoMoeda;
  double valorMoeda;
  double precoAtual;

  Investimento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipoMoeda,
    required this.valorMoeda,
    required this.precoAtual,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipoMoeda': tipoMoeda,
      'valorMoeda': valorMoeda,
      'precoAtual': precoAtual,
    };
  }

  factory Investimento.fromMap(Map<String, dynamic> map, String id) {
    return Investimento(
      id: id,
      nome: map['nome'],
      descricao: map['descricao'],
      tipoMoeda: map['tipoMoeda'],
      valorMoeda: map['valorMoeda'],
      precoAtual: map['precoAtual'],
    );
  }
}

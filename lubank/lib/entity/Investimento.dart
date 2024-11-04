class Investimento {
  String id;
  String nome;
  String descricao;

  Investimento({required this.id, required this.nome, required this.descricao});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'descricao': descricao};
  }

  factory Investimento.fromMap(Map<String, dynamic> map, String id) {
    return Investimento(id: id, nome: map['nome'], descricao: map['descricao']);
  }
}

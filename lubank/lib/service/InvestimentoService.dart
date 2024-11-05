import 'package:cloud_firestore/cloud_firestore.dart';
import '../../entity/Investimento.dart';

// Classe que gerencia as operações relacionadas a investimentos no Firestore
class InvestimentoService {
  // Referência para a coleção 'investimentos' no Firestore
  final CollectionReference collection = FirebaseFirestore.instance.collection('investimentos');

  // Método para adicionar um novo investimento ao Firestore
  Future<void> addInvestimento(Investimento investimento) async {
    // Converte o investimento para um mapa e adiciona à coleção
    await collection.add(investimento.toMap());
  }

  // Método que retorna um Stream de uma lista de investimentos
  Stream<List<Investimento>> getInvestimentos() {
    // Escuta as alterações na coleção e mapeia os dados para uma lista de objetos Investimento
    return collection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Investimento.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  // Método para atualizar um investimento existente no Firestore
  Future<void> updateInvestimento(Investimento investimento) async {
    // Atualiza o documento correspondente ao ID do investimento com os novos dados
    await collection.doc(investimento.id).update(investimento.toMap());
  }

  // Método para excluir um investimento do Firestore
  Future<void> deleteInvestimento(String id) async {
    // Remove o documento correspondente ao ID da coleção
    await collection.doc(id).delete();
  }
}

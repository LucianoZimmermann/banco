import 'package:cloud_firestore/cloud_firestore.dart';
import '../../entity/Investimento.dart';

class InvestimentoService {
  final CollectionReference collection = FirebaseFirestore.instance.collection('investimentos');

  // Método para adicionar um novo investimento ao Firestore
  Future<void> addInvestimento(Investimento investimento) async {
    await collection.add(investimento.toMap());
  }

  // Método que retorna um Stream de uma lista de investimentos
  Stream<List<Investimento>> getInvestimentos() {
    return collection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Investimento.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  // Método para atualizar um investimento existente no Firestore
  Future<void> updateInvestimento(Investimento investimento) async {
    await collection.doc(investimento.id).update(investimento.toMap());
  }

  // Método para excluir um investimento do Firestore
  Future<void> deleteInvestimento(String id) async {
    await collection.doc(id).delete();
  }

  // Novo método para salvar um investimento (adiciona ou atualiza com base no ID)
  Future<void> saveInvestimento(Investimento investimento) async {
    if (investimento.id.isEmpty) {
      // Adiciona um novo investimento se o ID estiver vazio
      await addInvestimento(investimento);
    } else {
      // Atualiza um investimento existente se o ID for fornecido
      await updateInvestimento(investimento);
    }
  }
}

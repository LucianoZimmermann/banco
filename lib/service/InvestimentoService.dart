import 'package:cloud_firestore/cloud_firestore.dart';
import '../../entity/Investimento.dart';

class InvestimentoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference collection = FirebaseFirestore.instance.collection('investimentos');

  // Método para adicionar um novo investimento ao Firestore
  Future<void> addInvestimento(Investimento investimento) async {
    await collection.add(investimento.toMap());
  }

  // Método que retorna um Stream de uma lista de investimentos
  Stream<List<Investimento>> getInvestimentos() {
    return FirebaseFirestore.instance
        .collection('investimentos') // Substitua pelo nome da sua coleção
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Investimento.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
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
    try {
      if (investimento.id.isEmpty) {
        throw ArgumentError('ID do investimento não pode estar vazio.');
      }

      final doc = collection.doc(investimento.id);
      final exists = (await doc.get()).exists;

      if (exists) {
        await doc.update(investimento.toMap());
      } else {
        await doc.set(investimento.toMap());
      }
    } catch (e) {
      throw Exception('Erro ao salvar investimento: $e');
    }
  }

}
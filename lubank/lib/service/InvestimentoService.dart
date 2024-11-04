import 'package:cloud_firestore/cloud_firestore.dart';
import '../../entity/Investimento.dart';

class InvestimentoService {
  final CollectionReference collection = FirebaseFirestore.instance.collection('investimentos');

  Future<void> addInvestimento(Investimento investimento) async {
    await collection.add(investimento.toMap());
  }

  Stream<List<Investimento>> getInvestimentos() {
    return collection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Investimento.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> updateInvestimento(Investimento investimento) async {
    await collection.doc(investimento.id).update(investimento.toMap());
  }

  Future<void> deleteInvestimento(String id) async {
    await collection.doc(id).delete();
  }
}

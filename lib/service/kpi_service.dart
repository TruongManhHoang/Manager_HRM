import 'package:admin_hrm/data/model/kpi/kpi_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KPIService {
  final _collection = FirebaseFirestore.instance.collection('kpis');

  Future<void> addKPI(KPIModel kpi) async {
    final docRef = _collection.doc(); // tự sinh ID
    final newKPI = kpi.copyWith(id: docRef.id); // tạo bản sao có id mới
    await docRef.set(newKPI.toJson());
  }

  Future<List<KPIModel>> getKPIsByUser(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => KPIModel.fromJson(doc.data())).toList();
  }

  Future<List<KPIModel>> getListKPI() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => KPIModel.fromJson(doc.data())).toList();
  }

  Future<void> updateKPI(KPIModel kpi) async {
    await _collection.doc(kpi.id).update(kpi.toJson());
  }

  Future<void> deleteKPI(String id) async {
    await _collection.doc(id).delete();
  }
}

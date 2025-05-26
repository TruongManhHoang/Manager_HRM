import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisciplinaryService {
  final CollectionReference _disciplinaryCollection =
      FirebaseFirestore.instance.collection('disciplinarys');

  Future<void> createDisciplinary(DisciplinaryModel disciplinary) async {
    final docRef = _disciplinaryCollection.doc();
    final disiplinaryWidId =
        disciplinary.copyWith(id: docRef.id, disciplinaryDate: DateTime.now());
    await docRef.set(disiplinaryWidId.toMap());
  }

  Future<void> updateDisciplinary(
      String id, DisciplinaryModel disciplinary) async {
    await _disciplinaryCollection.doc(id).update(disciplinary.toMap());
  }

  Future<void> deleteDisciplinary(String id) async {
    await _disciplinaryCollection.doc(id).delete();
  }

  Future<DisciplinaryModel?> getDisciplinaryById(String id) async {
    final doc = await _disciplinaryCollection.doc(id).get();
    if (doc.exists) {
      return DisciplinaryModel.fromFirestore(
          doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<DisciplinaryModel>> getAllDisciplinarys() async {
    final snapshot = await _disciplinaryCollection.get();
    return snapshot.docs
        .map((doc) =>
            DisciplinaryModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<DisciplinaryModel>> getAllDisciplinary() async {
    final snapshot = await _disciplinaryCollection
        .orderBy('disciplinaryDate', descending: true)
        .get();
    return snapshot.docs
        .map((doc) =>
            DisciplinaryModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<DisciplinaryModel>> streamAllDisciplinary() {
    return _disciplinaryCollection
        .orderBy('disciplinaryDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DisciplinaryModel.fromFirestore(
                doc.data() as Map<String, dynamic>))
            .toList());
  }
}

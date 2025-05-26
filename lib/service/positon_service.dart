import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/pages/position/add_position/add_position.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PositionService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addPosition(PositionModel positionModel) async {
    final docRef = _firestore.collection('positions').doc();
    final positionWithId = positionModel.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await docRef.set(positionWithId.toMap());
  }

  Future<List<PositionModel>> getPositions() async {
    final snapshot = await _firestore.collection('positions').get();

    return snapshot.docs
        .map((doc) => PositionModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> updatePosition(PositionModel position) async {
    await _firestore
        .collection('positions')
        .doc(position.id)
        .update(position.toMap());
  }

  Future<void> deletePosition(String id) async {
    await _firestore.collection('positions').doc(id).delete();
  }
}

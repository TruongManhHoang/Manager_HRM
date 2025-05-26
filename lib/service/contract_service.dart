import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/pages/position/add_position/add_position.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContractService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addContract(ContractModel contractModel) async {
    final docRef = _firestore.collection('contracts').doc();
    final contractWithId = contractModel.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await docRef.set(contractWithId.toMap());
  }

  Future<List<ContractModel>> getContracts() async {
    final snapshot = await _firestore.collection('contracts').get();

    return snapshot.docs
        .map((doc) => ContractModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateContract(ContractModel contract) async {
    await _firestore
        .collection('contracts')
        .doc(contract.id)
        .update(contract.toMap());
  }

  Future<void> deleteContract(String id) async {
    await _firestore.collection('contracts').doc(id).delete();
  }
}

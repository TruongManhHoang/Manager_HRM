import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/model/personnel_management.dart';

class PersionalService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addPersional(PersionalManagement persionalModel) async {
    final docRef = _firestore.collection('personnel').doc();
    final persionalWithId = persionalModel.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'đang làm việc');
    await docRef.set(persionalWithId.toMap());
  }

  //  method to update existing personnel
  void updatePersionel(PersionalManagement personnel) async {
    try {
      await _firestore
          .collection('personnel')
          .doc(personnel.id)
          .update(personnel.toMap());
      print('Update successfully!');
    } catch (e) {
      print('Fail to update!: $e');
    }
  }

  //  method to delete personnel
  void deletePersonnel(String id) async {
    try {
      await _firestore.collection('personnel').doc(id).delete();
      print('Delete successfully!');
    } catch (e) {
      print('Fail to delete: $e');
    }
  }

  //  method to retrieve all personnel
  Future<List<PersionalManagement>> getAllPersonnel() async {
    // final snapshot = await _firestore.collection('positions').get();

    // return snapshot.docs
    //     .map((doc) => PersonnelManagement.fromMap(doc.data()))
    //     .toList();
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('personnel').get();
      print('Get personnel successfully!');

      return querySnapshot.docs
          .map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              print('Document data: $data');
              return PersionalManagement.fromMap(data);
            } catch (e) {
              print('Lỗi parse document ${doc.id}: $e');
              return null;
            }
          })
          .whereType<PersionalManagement>()
          .toList();
    } catch (e) {
      print('Fail to read: $e');
      return [];
    }
  }
}

import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addDepartment(DepartmentModel departmentModel) async {
    final docRef = _firestore.collection('departments').doc();
    final departmentWithId = departmentModel.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await docRef.set(departmentWithId.toMap());
  }

  Future<List<DepartmentModel>> getDepartments() async {
    final snapshot = await _firestore.collection('departments').get();

    return snapshot.docs
        .map((doc) => DepartmentModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateDepartment(DepartmentModel department) async {
    await _firestore
        .collection('departments')
        .doc(department.id)
        .update(department.toMap());
  }

  Future<void> deleteDepartment(String id) async {
    await _firestore.collection('departments').doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> getDepartmentList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('departments').get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              'name': doc['name'],
            })
        .toList();
  }
}

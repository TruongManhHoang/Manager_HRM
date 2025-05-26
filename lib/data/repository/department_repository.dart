import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:admin_hrm/service/department_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentRepository {
  final DepartmentService _departmentService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DepartmentRepository(this._departmentService);
  Future<void> createDepartment(DepartmentModel departmentModel) async {
    await _departmentService.addDepartment(departmentModel);
  }

  Future<List<DepartmentModel>> getDepartments() async {
    return await _departmentService.getDepartments();
  }

  Future<void> updateDepartment(DepartmentModel departmentModel) async {
    await _departmentService.updateDepartment(departmentModel);
  }

  Future<void> deleteDepartment(String id) async {
    await _departmentService.deleteDepartment(id);
  }

  Future<void> increaseEmployeeCount(String departmentId) async {
    final ref = _firestore.collection('departments').doc(departmentId);
    await ref.update({'employeeCount': FieldValue.increment(1)});
  }

  Future<void> decreaseEmployeeCount(String departmentId) async {
    final ref = _firestore.collection('departments').doc(departmentId);
    await ref.update({'employeeCount': FieldValue.increment(-1)});
  }
}

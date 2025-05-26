import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:admin_hrm/service/department_service.dart';
import 'package:admin_hrm/service/salary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalaryRepository {
  final SalaryService _salaryService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SalaryRepository(this._salaryService);
  Future<void> createSalary(SalaryModel salaryModel) async {
    await _salaryService.addSalary(salaryModel);
  }

  Future<List<SalaryModel>> getSalaries() async {
    return await _salaryService.getSalaries();
  }

  Future<void> updateSalary(SalaryModel salaryModel) async {
    await _salaryService.updateSalary(salaryModel);
  }

  Future<void> deleteSalary(String id) async {
    await _salaryService.deleteSalary(id);
  }

  Future<List<SalaryModel>> getSalariesByEmployeeId(String employeeId) async {
    return await _salaryService.getSalariesByEmployeeId(employeeId);
  }

  // Future<void> increaseEmployeeCount(String departmentId) async {
  //   final ref = _firestore.collection('departments').doc(departmentId);
  //   await ref.update({'employeeCount': FieldValue.increment(1)});
  // }

  // Future<void> decreaseEmployeeCount(String departmentId) async {
  //   final ref = _firestore.collection('departments').doc(departmentId);
  //   await ref.update({'employeeCount': FieldValue.increment(-1)});
  // }
}

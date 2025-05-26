import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalaryService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addSalary(SalaryModel salaryModel) async {
    final docRef = _firestore.collection('salaries').doc();
    final salaryWithId = salaryModel.copyWith(
      id: docRef.id,
      payDate: DateTime.now(),
    );
    await docRef.set(salaryWithId.toMap());
  }

  Future<List<SalaryModel>> getSalaries() async {
    final snapshot = await _firestore.collection('salaries').get();

    return snapshot.docs
        .map((doc) => SalaryModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateSalary(SalaryModel salary) async {
    await _firestore
        .collection('salaries')
        .doc(salary.id)
        .update(salary.toMap());
  }

  Future<void> deleteSalary(String id) async {
    await _firestore.collection('salaries').doc(id).delete();
  }

  Future<List<SalaryModel>> getSalariesByEmployeeId(String employeeId) async {
    final snapshot = await _firestore
        .collection('salaries')
        .where('employeeId', isEqualTo: employeeId)
        .get();

    return snapshot.docs
        .map((doc) => SalaryModel.fromJson(doc.data()))
        .toList();
  }

  // Future<List<Map<String, dynamic>>> getSalaryList() async {
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection('salaries').get();
  //   return snapshot.docs
  //       .map((doc) => {
  //             'id': doc.id,
  //             'employeeId': doc['employeeId'],
  //             'baseSalary': doc['baseSalary'],
  //             'kpiBonus': doc['kpiBonus'],
  //             'rewardBonus': doc['rewardBonus'],
  //             'disciplinaryDeduction': doc['disciplinaryDeduction'],
  //             'attendanceBonus': doc['attendanceBonus'],
  //             'absenceDeduction': doc['absenceDeduction'],
  //             'totalSalary': doc['totalSalary'],
  //             'payDate': doc['payDate'],
  //           })
  //       .toList();
  // }
}

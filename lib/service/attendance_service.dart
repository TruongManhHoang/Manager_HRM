import 'package:admin_hrm/data/model/attendance/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final _collection = FirebaseFirestore.instance.collection('attendances');

  Future<void> addAttendance(AttendanceModel model) async {
    final docRef = FirebaseFirestore.instance.collection('attendances').doc();
    final newModel = model.copyWith(id: docRef.id);
    await docRef.set(newModel.toJson());
  }

  Future<List<AttendanceModel>> getAttendancesByUser(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => AttendanceModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<AttendanceModel>> getAllAttendances() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => AttendanceModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateAttendance(AttendanceModel attendance) async {
    await _collection.doc(attendance.id).update(attendance.toJson());
  }

  Future<void> deleteAttendance(String id) async {
    await _collection.doc(id).delete();
  }
}

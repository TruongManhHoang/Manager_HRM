import 'package:admin_hrm/data/model/attendance/attendance_model.dart';

abstract class AttendanceEvent {}

class LoadAttendances extends AttendanceEvent {
  LoadAttendances();
}

class AddAttendance extends AttendanceEvent {
  final AttendanceModel attendance;
  AddAttendance(this.attendance);
}

class UpdateAttendance extends AttendanceEvent {
  final AttendanceModel attendance;
  UpdateAttendance(this.attendance);
}

class SearchAttendance extends AttendanceEvent {
  final String query;
  SearchAttendance(this.query);
}

class FilterAttendance extends AttendanceEvent {
  final int month;
  final int year;
  FilterAttendance({required this.month, required this.year});
}

class DeleteAttendance extends AttendanceEvent {
  final String id;
  final String userId;
  DeleteAttendance(this.id, this.userId);
}

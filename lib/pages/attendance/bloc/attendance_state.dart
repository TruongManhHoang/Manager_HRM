// File: blocs/attendance/attendance_state.dart
import 'package:admin_hrm/data/model/attendance/attendance_model.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceModel> attendances;
  AttendanceLoaded(this.attendances);
}

class AttendanceSuccess extends AttendanceState {
  AttendanceSuccess();
}

class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);
}

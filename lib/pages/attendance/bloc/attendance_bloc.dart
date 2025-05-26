import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_event.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_state.dart';
import 'package:admin_hrm/service/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceService service;
  final GlobalStorage globalStorage;

  AttendanceBloc(this.service, this.globalStorage)
      : super(AttendanceInitial()) {
    on<LoadAttendances>(_onLoad);
    on<AddAttendance>(_onAdd);
    on<UpdateAttendance>(_onUpdate);
    on<DeleteAttendance>(_onDelete);
  }

  Future<void> _onLoad(LoadAttendances event, Emitter emit) async {
    emit(AttendanceLoading());
    try {
      debugPrint("Loading Attendances");
      final list = await service.getAllAttendances();
      debugPrint("Attendances Loaded: ${list.length}");
      globalStorage.fetchAllAttendance(list);
      emit(AttendanceLoaded(list));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onAdd(AddAttendance event, Emitter emit) async {
    try {
      await service.addAttendance(event.attendance);
      emit(AttendanceSuccess());
      add(LoadAttendances());
    } catch (e) {
      debugPrint(e.toString());
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateAttendance event, Emitter emit) async {
    try {
      await service.updateAttendance(event.attendance);
      emit(AttendanceSuccess());
      add(LoadAttendances());
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteAttendance event, Emitter emit) async {
    try {
      await service.deleteAttendance(event.id);
      emit(AttendanceSuccess());
      add(LoadAttendances());
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}

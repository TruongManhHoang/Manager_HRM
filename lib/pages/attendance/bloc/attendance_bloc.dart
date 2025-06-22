import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_event.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_state.dart';
import 'package:admin_hrm/service/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceService service;
  final GlobalStorage globalStorage;

  AttendanceBloc(this.service, this.globalStorage)
      : super(AttendanceInitial()) {
    on<LoadAttendances>(_onLoad);
    on<AddAttendance>(_onAdd);
    on<UpdateAttendance>(_onUpdate);
    on<DeleteAttendance>(_onDelete);
    on<SearchAttendance>(_onSearch);
    on<FilterAttendance>(_onFilterAttendance);
  }

  String removeDiacritics(String text) {
    const vietnamese =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    const normalized =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuuuuuuuyyyyyd';

    String result = text.toLowerCase();

    for (int i = 0; i < vietnamese.length; i++) {
      result = result.replaceAll(vietnamese[i], normalized[i]);
    }

    return result;
  }

  Future<void> _onFilterAttendance(FilterAttendance event, Emitter emit) async {
    emit(AttendanceLoading());
    try {
      final allAttendance = globalStorage.attendances ?? [];
      final dateFormat = DateFormat('yyyy-MM-dd');
      final filtered = allAttendance.where((attendance) {
        if (attendance.date == null) return false;
        try {
          final date = dateFormat.parse(attendance.date!);
          return date.month == event.month && date.year == event.year;
        } catch (_) {
          return false;
        }
      }).toList();
      emit(AttendanceLoaded(filtered));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onSearch(SearchAttendance event, Emitter emit) async {
    emit(AttendanceLoading());
    try {
      final allAttendance = globalStorage.attendances ?? [];
      final query = event.query.trim();

      if (query.isEmpty) {
        emit(AttendanceLoaded(allAttendance));
        return;
      }

      final normalizedQuery = removeDiacritics(query.toLowerCase());

      final list = allAttendance.where((attendance) {
        final userName = attendance.userName?.toLowerCase() ?? '';
        final date = attendance.date?.toLowerCase() ?? '';
        final normalizedUserName = removeDiacritics(userName);
        final normalizedDate = removeDiacritics(date);

        return userName.contains(query.toLowerCase()) ||
            date.contains(query.toLowerCase()) ||
            normalizedUserName.contains(normalizedQuery) ||
            normalizedDate.contains(normalizedQuery);
      }).toList();

      emit(AttendanceLoaded(list));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
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

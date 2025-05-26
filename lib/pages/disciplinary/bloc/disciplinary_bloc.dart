import 'package:admin_hrm/data/repository/disciplinary_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_event.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisciplinaryBloc extends Bloc<DisciplinaryEvent, DisciplinaryState> {
  final DisciplinaryRepository repository;
  final GlobalStorage globalStorage;

  DisciplinaryBloc(this.repository, this.globalStorage)
      : super(DisciplinaryInitial()) {
    on<LoadDisciplinary>(_onLoadDisciplinary);
    on<AddDisciplinary>(_onAddDisciplinary);
    on<UpdateDisciplinary>(_onUpdateDisciplinary);
    on<DeleteDisciplinary>(_onDeleteDisciplinary);
  }

  Future<void> _onLoadDisciplinary(
      LoadDisciplinary event, Emitter<DisciplinaryState> emit) async {
    emit(DisciplinaryLoading());
    try {
      final disciplinary = await repository.getAllDisciplinarys();
      emit(DisciplinaryLoaded(disciplinary));
      globalStorage.fetchAllDisciplinaryActions(disciplinary);
    } catch (e) {
      emit(DisciplinaryError('Không thể tải danh sách kỷ luật'));
    }
  }

  Future<void> _onAddDisciplinary(
      AddDisciplinary event, Emitter<DisciplinaryState> emit) async {
    try {
      await repository.addDisciplinary(event.disciplinary);
      emit(DisciplinarySuccess());
      add(LoadDisciplinary());
    } catch (e) {
      emit(DisciplinaryError('Thêm kỷ luật thất bại'));
    }
  }

  Future<void> _onUpdateDisciplinary(
      UpdateDisciplinary event, Emitter<DisciplinaryState> emit) async {
    try {
      await repository.updateDisciplinary(event.disciplinary);
      emit(DisciplinarySuccess());
      add(LoadDisciplinary());
    } catch (e) {
      emit(DisciplinaryError('Cập nhật kỷ luật thất bại'));
    }
  }

  Future<void> _onDeleteDisciplinary(
      DeleteDisciplinary event, Emitter<DisciplinaryState> emit) async {
    try {
      await repository.deleteDisciplinary(event.disciplinaryId);
      emit(DisciplinarySuccess());
      add(LoadDisciplinary());
    } catch (e) {
      emit(DisciplinaryError('Xóa kỷ luật thất bại'));
    }
  }
}

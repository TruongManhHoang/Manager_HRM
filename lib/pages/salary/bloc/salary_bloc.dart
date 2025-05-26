import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:admin_hrm/data/repository/salary_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'salary_event.dart';
part 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  final SalaryRepository salaryRepository;

  SalaryBloc({required this.salaryRepository}) : super(SalaryInitial()) {
    on<CreateSalary>(_onCreateSalary);
    on<GetListSalary>(_onGetListSalary);
    on<UpdateSalary>(_onUpdateSalary);
    on<DeleteSalary>(_onDeleteSalary);
    on<GetListSalaryByEmployeeId>(_onGetListSalaryByEmployeeId);
  }

  Future<void> _onCreateSalary(
    CreateSalary event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryLoading());
    try {
      await salaryRepository.createSalary(event.salary);
      emit(SalarySuccess());
      add(GetListSalary());
    } catch (e) {
      emit(SalaryFailure(e.toString()));
    }
  }

  Future<void> _onGetListSalary(
    GetListSalary event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryLoading());
    try {
      final salaries = await salaryRepository.getSalaries();
      emit(SalaryLoaded(salaries));
    } catch (e) {
      emit(SalaryFailure(e.toString()));
    }
  }

  Future<void> _onGetListSalaryByEmployeeId(
    GetListSalaryByEmployeeId event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryLoading());
    try {
      final salaries =
          await salaryRepository.getSalariesByEmployeeId(event.employeeId);
      emit(SalaryByEmployeeIdLoaded(salaries));
    } catch (e) {
      emit(SalaryFailure(e.toString()));
    }
  }

  Future<void> _onUpdateSalary(
    UpdateSalary event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryLoading());
    try {
      await salaryRepository.updateSalary(event.salary);
      emit(SalarySuccess());
    } catch (e) {
      emit(SalaryFailure(e.toString()));
    }
  }

  Future<void> _onDeleteSalary(
    DeleteSalary event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryLoading());
    try {
      await salaryRepository.deleteSalary(event.id);
      emit(SalarySuccess());
      add(GetListSalary());
    } catch (e) {
      emit(SalaryFailure(e.toString()));
    }
  }
}

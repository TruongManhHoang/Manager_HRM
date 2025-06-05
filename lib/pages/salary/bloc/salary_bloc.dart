import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:admin_hrm/data/repository/salary_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'salary_event.dart';
part 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  final SalaryRepository salaryRepository;
  final GlobalStorage globalStorage;

  SalaryBloc({required this.salaryRepository, required this.globalStorage})
      : super(SalaryInitial()) {
    on<CreateSalary>(_onCreateSalary);
    on<GetListSalary>(_onGetListSalary);
    on<UpdateSalary>(_onUpdateSalary);
    on<DeleteSalary>(_onDeleteSalary);
    on<GetListSalaryByEmployeeId>(_onGetListSalaryByEmployeeId);
    on<FilterSalaryEvent>(_onFilterSalary);
    on<QuerySalary>(_onQuerySalary);
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

  Future<void> _onQuerySalary(
    QuerySalary event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryLoading());
    try {
      final allSalaries = globalStorage.salaries ?? [];

      if (event.query.isEmpty) {
        emit(SalaryLoaded(allSalaries));
        return;
      }

      final personalManagers = globalStorage.personalManagers ?? [];

      // ✅ Chuyển đổi query thành không dấu
      final normalizedQuery = removeDiacritics(event.query);

      final queryEmployee = personalManagers.where((employee) {
        if (employee.name == null) return false;

        // ✅ So sánh cả tên gốc và tên không dấu
        final originalName = employee.name!.toLowerCase();
        final normalizedName = removeDiacritics(employee.name!);

        return originalName.contains(event.query.toLowerCase()) ||
            normalizedName.contains(normalizedQuery);
      }).toList();

      if (queryEmployee.isEmpty) {
        emit(SalaryLoaded([]));
        return;
      }

      final filteredSalaries = allSalaries
          .where((salary) =>
              queryEmployee.any((employee) => employee.id == salary.employeeId))
          .toList();

      emit(SalaryLoaded(filteredSalaries));
    } catch (e) {
      debugPrint('Error in query salary: $e');
      emit(SalaryFailure(e.toString()));
    }
  }

  Future<void> _onFilterSalary(
    FilterSalaryEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryLoading());
    try {
      final allSalaries = globalStorage.salaries ?? [];

      // Nếu chọn "Tất cả" hoặc không có filter
      if (event.selectedMonth == null || event.selectedMonth == "all") {
        emit(SalaryLoaded(allSalaries));
        return;
      }

      // Lọc theo tháng được chọn
      final filteredSalaries = allSalaries.where((salary) {
        if (salary.payDate == null) return false;

        // Chuyển đổi createdAt thành format "yyyy-MM"
        final salaryMonth =
            "${salary.payDate!.year}-${salary.payDate!.month.toString().padLeft(2, '0')}";
        return salaryMonth == event.selectedMonth;
      }).toList();

      emit(SalaryLoaded(filteredSalaries));
    } catch (e) {
      emit(SalaryFailure(e.toString()));
    }
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
      globalStorage.fetchAllSalary(salaries);
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
      add(GetListSalary());
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

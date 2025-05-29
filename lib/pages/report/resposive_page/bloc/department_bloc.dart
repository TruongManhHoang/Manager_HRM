import 'package:admin_hrm/data/repository/department_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/department/bloc/department_event.dart';
import 'package:admin_hrm/pages/department/bloc/department_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository repository;
  final GlobalStorage globalStorage;

  DepartmentBloc({required this.repository, required this.globalStorage})
      : super(DepartmentInitial()) {
    on<CreateDepartment>(_onCreateDepartment);
    on<GetListDepartment>(_onGetListDepartment);
    on<UpdateDepartment>(_onUpdateDepartment);
    on<DeleteDepartment>(_onDeleteDepartment);
  }

  Future<void> _onCreateDepartment(
    CreateDepartment event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      await repository.createDepartment(event.department);
      globalStorage.addToDepartment(event.department);
      emit(DepartmentSuccess());
      add(GetListDepartment());
    } catch (e) {
      emit(DepartmentFailure(e.toString()));
    }
  }

  Future<void> _onGetListDepartment(
    GetListDepartment event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      final departments = await repository.getDepartments();
      globalStorage.fetchAllDepartment(departments);
      emit(DepartmentLoaded(departments));
    } catch (e) {
      emit(DepartmentFailure(e.toString()));
    }
  }

  Future<void> _onUpdateDepartment(
    UpdateDepartment event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      await repository.updateDepartment(event.department);
      globalStorage.updateDepartment(event.department);
      emit(DepartmentSuccess());
      add(GetListDepartment());
    } catch (e) {
      emit(DepartmentFailure(e.toString()));
    }
  }

  Future<void> _onDeleteDepartment(
    DeleteDepartment event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      await repository.deleteDepartment(event.id);
      globalStorage.removeFromDepartmentById(event.id);
      emit(DepartmentSuccess());
      add(GetListDepartment());
    } catch (e) {
      emit(DepartmentFailure(e.toString()));
    }
  }
}

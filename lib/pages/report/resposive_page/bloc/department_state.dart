import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:equatable/equatable.dart';

abstract class DepartmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentSuccess extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<DepartmentModel> departments;

  DepartmentLoaded(this.departments);

  @override
  List<Object?> get props => [departments];
}

class DepartmentFailure extends DepartmentState {
  final String error;

  DepartmentFailure(this.error);

  @override
  List<Object?> get props => [error];
}

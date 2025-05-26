part of 'salary_bloc.dart';

abstract class SalaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SalaryInitial extends SalaryState {}

class SalaryLoading extends SalaryState {}

class SalarySuccess extends SalaryState {
  SalarySuccess();

  @override
  List<Object?> get props => [];
}

class SalaryLoaded extends SalaryState {
  final List<SalaryModel> salaries;

  SalaryLoaded(this.salaries);

  @override
  List<Object?> get props => [salaries];
}

class SalaryByEmployeeIdLoaded extends SalaryState {
  final List<SalaryModel> salaries;

  SalaryByEmployeeIdLoaded(this.salaries);

  @override
  List<Object?> get props => [salaries];
}

class SalaryFailure extends SalaryState {
  final String error;

  SalaryFailure(this.error);

  @override
  List<Object?> get props => [error];
}

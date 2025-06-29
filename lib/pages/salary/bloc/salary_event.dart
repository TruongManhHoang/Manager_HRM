part of 'salary_bloc.dart';

abstract class SalaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateSalary extends SalaryEvent {
  final SalaryModel salary;

  CreateSalary(this.salary);

  @override
  List<Object?> get props => [salary];
}

class GetListSalary extends SalaryEvent {
  GetListSalary();

  @override
  List<Object?> get props => [];
}

class QuerySalary extends SalaryEvent {
  final String query;

  QuerySalary(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterSalaryEvent extends SalaryEvent {
  final String selectedMonth;
  FilterSalaryEvent(this.selectedMonth);

  @override
  List<Object?> get props => [selectedMonth];
}

class GetListSalaryByEmployeeId extends SalaryEvent {
  final String employeeId;

  GetListSalaryByEmployeeId(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class UpdateSalary extends SalaryEvent {
  final SalaryModel salary;

  UpdateSalary(this.salary);

  @override
  List<Object?> get props => [salary];
}

class DeleteSalary extends SalaryEvent {
  final String id;

  DeleteSalary(this.id);

  @override
  List<Object?> get props => [id];
}

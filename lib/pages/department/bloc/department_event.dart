import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:equatable/equatable.dart';

abstract class DepartmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateDepartment extends DepartmentEvent {
  final DepartmentModel department;

  CreateDepartment(this.department);

  @override
  List<Object?> get props => [department];
}

class GetListDepartment extends DepartmentEvent {
  GetListDepartment();

  @override
  List<Object?> get props => [];
}

class UpdateDepartment extends DepartmentEvent {
  final DepartmentModel department;

  UpdateDepartment(this.department);

  @override
  List<Object?> get props => [department];
}

class DeleteDepartment extends DepartmentEvent {
  final String id;

  DeleteDepartment(this.id);

  @override
  List<Object?> get props => [id];
}

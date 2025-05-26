import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:equatable/equatable.dart';

abstract class DisciplinaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDisciplinary extends DisciplinaryEvent {}

class AddDisciplinary extends DisciplinaryEvent {
  final DisciplinaryModel disciplinary;

  AddDisciplinary(this.disciplinary);

  @override
  List<Object?> get props => [disciplinary];
}

class UpdateDisciplinary extends DisciplinaryEvent {
  final DisciplinaryModel disciplinary;

  UpdateDisciplinary(this.disciplinary);

  @override
  List<Object?> get props => [disciplinary];
}

class DeleteDisciplinary extends DisciplinaryEvent {
  final String disciplinaryId;

  DeleteDisciplinary(this.disciplinaryId);

  @override
  List<Object?> get props => [disciplinaryId];
}

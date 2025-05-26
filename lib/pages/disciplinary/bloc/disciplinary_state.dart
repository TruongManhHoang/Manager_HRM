import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:equatable/equatable.dart';

abstract class DisciplinaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DisciplinaryInitial extends DisciplinaryState {}

class DisciplinaryLoading extends DisciplinaryState {}

class DisciplinarySuccess extends DisciplinaryState {}

class DisciplinaryLoaded extends DisciplinaryState {
  final List<DisciplinaryModel> disciplinary;

  DisciplinaryLoaded(this.disciplinary);

  @override
  List<Object?> get props => [disciplinary];
}

class DisciplinaryError extends DisciplinaryState {
  final String message;

  DisciplinaryError(this.message);

  @override
  List<Object?> get props => [message];
}

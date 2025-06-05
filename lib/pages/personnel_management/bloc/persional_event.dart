part of 'persional_bloc.dart';

class PersionalEvent extends Equatable {
  const PersionalEvent();

  @override
  List<Object?> get props => [];
}

class PersonalFetchEvent extends PersionalEvent {
  const PersonalFetchEvent();

  @override
  List<Object?> get props => [];
}

class PersionalLoadEvent extends PersionalEvent {
  const PersionalLoadEvent();
  @override
  List<Object?> get props => [];
}

class PersionalCreateEvent extends PersionalEvent {
  final PersionalManagement personnelManagement;
  // final XFile? image;

  const PersionalCreateEvent(
    this.personnelManagement,
  );

  @override
  List<Object?> get props => [personnelManagement];
}

class SearchPersionalEvent extends PersionalEvent {
  final String query;
  // final XFile? image;

  const SearchPersionalEvent(
    this.query,
  );

  @override
  List<Object?> get props => [query];
}

class PersionalUpdateEvent extends PersionalEvent {
  final PersionalManagement personnelManagement;
  final String? oldDepartmentId;

  const PersionalUpdateEvent(
    this.personnelManagement,
    this.oldDepartmentId,
  );
  @override
  List<Object?> get props => [personnelManagement];
}

class FilterPersionalByStatusEvent extends PersionalEvent {
  final String status;

  const FilterPersionalByStatusEvent(this.status);
  @override
  List<Object?> get props => [status];
}

class PersionalDeleteEvent extends PersionalEvent {
  final String id;
  final String? departmentId;

  const PersionalDeleteEvent(
    this.id,
    this.departmentId,
  );
  @override
  List<Object?> get props => [id];
}

part of 'position_bloc.dart';

class PositionEvent extends Equatable {
  const PositionEvent();

  @override
  List<Object?> get props => [];
}

class CreatePosition extends PositionEvent {
  final PositionModel positionModel;

  CreatePosition(this.positionModel);

  @override
  List<Object?> get props => [positionModel];
}

class GetListPosition extends PositionEvent {
  GetListPosition();

  @override
  List<Object?> get props => [];
}

class UpdatePosition extends PositionEvent {
  final PositionModel positionModel;

  UpdatePosition(this.positionModel);

  @override
  List<Object?> get props => [positionModel];
}

class DeletePosition extends PositionEvent {
  final String id;

  DeletePosition(this.id);

  @override
  List<Object?> get props => [id];
}

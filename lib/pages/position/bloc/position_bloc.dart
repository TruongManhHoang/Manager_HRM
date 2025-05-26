import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/data/repository/positiion_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'position_state.dart';
part 'position_event.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  final PositiionRepository repository;
  final GlobalStorage globalStorage;

  PositionBloc({required this.repository, required this.globalStorage})
      : super(const PositionState()) {
    on<CreatePosition>(_createPosition);
    on<GetListPosition>(_getListPosition);
    on<UpdatePosition>(_updatePosition);
    on<DeletePosition>(_deletePosition);
  }

  void _createPosition(
    CreatePosition event,
    Emitter<PositionState> emit,
  ) async {
    emit(state.copyWith());
    try {
      await repository.createPosition(event.positionModel);
      globalStorage.addToPosition(event.positionModel);
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(GetListPosition());
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }

  void _getListPosition(
    GetListPosition event,
    Emitter<PositionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      final positions = await repository.getPositions();
      globalStorage.fetchAllPosition(positions);
      emit(state.copyWith(
          isLoading: false, positions: positions, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }

  void _updatePosition(
    UpdatePosition event,
    Emitter<PositionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await repository.updatePosition(event.positionModel);
      globalStorage.updatePosition(event.positionModel);
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(GetListPosition());
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }

  void _deletePosition(
    DeletePosition event,
    Emitter<PositionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await repository.deletePosition(event.id);
      globalStorage.removeFromPositionById(event.id);
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(GetListPosition());
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }
}

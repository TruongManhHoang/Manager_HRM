import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/data/repository/contract_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'contract_state.dart';
part 'contrac_event.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final ContractRepository repository;
  final GlobalStorage globalStorage;
  ContractBloc({required this.repository, required this.globalStorage})
      : super(const ContractState()) {
    on<CreateContract>(_createContract);
    on<GetListContract>(_getListContract);
    on<UpdateContract>(_updateContract);
    on<DeleteContract>(_deleteContract);
  }

  void _createContract(
    CreateContract event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await repository.createContract(event.contractModel);
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(GetListContract());
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }

  void _getListContract(
    GetListContract event,
    Emitter<ContractState> emit,
  ) async {
    debugPrint('GetListContract');
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      final contracts = await repository.getContracts();
      globalStorage.fetchAllContracts(contracts);
      debugPrint('GetListContract: ${contracts}');
      emit(state.copyWith(
          isLoading: false, contracts: contracts, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }

  void _updateContract(
    UpdateContract event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await repository.updateContract(event.contractModel);
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(GetListContract());
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }

  void _deleteContract(
    DeleteContract event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await repository.deleteContract(event.id);
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(GetListContract());
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: e.toString()));
    }
  }
}

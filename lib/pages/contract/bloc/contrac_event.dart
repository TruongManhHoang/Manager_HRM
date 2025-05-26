part of 'contract_bloc.dart';

class ContractEvent extends Equatable {
  const ContractEvent();

  @override
  List<Object?> get props => [];
}

class CreateContract extends ContractEvent {
  final ContractModel contractModel;

  CreateContract(this.contractModel);

  @override
  List<Object?> get props => [contractModel];
}

class GetListContract extends ContractEvent {
  GetListContract();

  @override
  List<Object?> get props => [];
}

class UpdateContract extends ContractEvent {
  final ContractModel contractModel;

  UpdateContract(this.contractModel);

  @override
  List<Object?> get props => [contractModel];
}

class DeleteContract extends ContractEvent {
  final String id;

  DeleteContract(this.id);

  @override
  List<Object?> get props => [id];
}

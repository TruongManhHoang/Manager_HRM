part of 'contract_bloc.dart';

class ContractState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String? error;
  final List<ContractModel> contracts;

  const ContractState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.error,
    this.contracts = const [],
  });

  factory ContractState.initial() => const ContractState();

  ContractState copyWith({
    final bool? isLoading,
    final bool? isSuccess,
    final bool? isFailure,
    final String? error,
    final List<ContractModel>? contracts,
  }) {
    return ContractState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      error: error ?? this.error,
      contracts: contracts ?? this.contracts,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        isFailure,
        error,
        contracts,
      ];
}

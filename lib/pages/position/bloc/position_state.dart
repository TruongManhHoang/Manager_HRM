part of 'position_bloc.dart';

class PositionState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String? error;
  final List<PositionModel> positions;

  const PositionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.error,
    this.positions = const [],
  });

  factory PositionState.inital() => const PositionState();

  PositionState copyWith({
    final bool? isLoading,
    final bool? isSuccess,
    final bool? isFailure,
    final String? error,
    final List<PositionModel>? positions,
  }) {
    return PositionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      error: error ?? this.error,
      positions: positions ?? this.positions,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        isFailure,
        error,
        positions,
      ];
}

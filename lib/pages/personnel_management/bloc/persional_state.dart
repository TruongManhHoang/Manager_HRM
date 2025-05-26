part of 'persional_bloc.dart';

class PersionalState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<PersionalManagement>? personnel;
  final PersionalManagement? persionalManagement;
  final bool isSuccess;
  final bool isFailure;

  const PersionalState(
      {this.isLoading = false,
      this.errorMessage,
      this.personnel,
      this.isSuccess = false,
      this.isFailure = false,
      this.persionalManagement});
  factory PersionalState.initial() => const PersionalState();

  PersionalState copyWith(
      {bool? isLoading,
      String? errorMessage,
      List<PersionalManagement>? personnel,
      bool? isSuccess,
      bool? isFailure,
      PersionalManagement? persionalManagement}) {
    return PersionalState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        personnel: personnel ?? this.personnel,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        persionalManagement: persionalManagement ?? this.persionalManagement);
  }

  @override
  List<Object> get props => [
        isLoading,
        errorMessage ?? '',
        personnel ?? [],
        isSuccess,
        isFailure,
        persionalManagement ?? ''
      ];
}

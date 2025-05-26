import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:equatable/equatable.dart';

abstract class RewardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RewardInitial extends RewardState {}

class RewardLoading extends RewardState {}

class RewardSuccess extends RewardState {}

class RewardLoaded extends RewardState {
  final List<RewardModel> rewards;

  RewardLoaded(this.rewards);

  @override
  List<Object?> get props => [rewards];
}

class RewardError extends RewardState {
  final String message;

  RewardError(this.message);

  @override
  List<Object?> get props => [message];
}

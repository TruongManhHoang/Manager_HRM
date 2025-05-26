import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:equatable/equatable.dart';

abstract class RewardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRewards extends RewardEvent {}

class AddReward extends RewardEvent {
  final RewardModel reward;

  AddReward(this.reward);

  @override
  List<Object?> get props => [reward];
}

class UpdateReward extends RewardEvent {
  final RewardModel reward;

  UpdateReward(this.reward);

  @override
  List<Object?> get props => [reward];
}

class DeleteReward extends RewardEvent {
  final String rewardId;

  DeleteReward(this.rewardId);

  @override
  List<Object?> get props => [rewardId];
}

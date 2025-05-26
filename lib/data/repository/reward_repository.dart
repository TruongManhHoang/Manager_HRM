import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:admin_hrm/service/reward_service.dart';

class RewardRepository {
  final RewardService _service;

  RewardRepository(this._service);

  Future<void> addReward(RewardModel reward) => _service.createReward(reward);

  Future<void> updateReward(RewardModel reward) =>
      _service.updateReward(reward);

  Future<void> deleteReward(String id) => _service.deleteReward(id);

  Future<RewardModel?> getReward(String id) => _service.getRewardById(id);

  Future<List<RewardModel>> getAllRewards() => _service.getAllReward();

  Future<List<RewardModel>> fetchAllRewards() => _service.getAllRewards();

  Stream<List<RewardModel>> watchAllRewards() => _service.streamAllRewards();
}

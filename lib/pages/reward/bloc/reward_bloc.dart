import 'package:admin_hrm/data/repository/reward_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reward_event.dart';
import 'reward_state.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final RewardRepository repository;
  final GlobalStorage globalStorage;

  RewardBloc(this.repository, this.globalStorage) : super(RewardInitial()) {
    on<LoadRewards>(_onLoadRewards);
    on<AddReward>(_onAddReward);
    on<UpdateReward>(_onUpdateReward);
    on<DeleteReward>(_onDeleteReward);
  }

  Future<void> _onLoadRewards(
      LoadRewards event, Emitter<RewardState> emit) async {
    emit(RewardLoading());
    try {
      debugPrint('Loading rewards...');
      final rewards = await repository.getAllRewards();
      emit(RewardLoaded(rewards));
      globalStorage.fetchAllRewards(rewards);
    } catch (e) {
      emit(RewardError('Không thể tải danh sách khen thưởng'));
    }
  }

  Future<void> _onAddReward(AddReward event, Emitter<RewardState> emit) async {
    try {
      debugPrint('Adding reward: ');
      await repository.addReward(event.reward);
      emit(RewardSuccess());
      add(LoadRewards());
    } catch (e) {
      emit(RewardError('Thêm khen thưởng thất bại'));
    }
  }

  Future<void> _onUpdateReward(
      UpdateReward event, Emitter<RewardState> emit) async {
    try {
      debugPrint('Updating reward: ${event.reward}');
      await repository.updateReward(event.reward);
      emit(RewardSuccess());
      add(LoadRewards());
    } catch (e) {
      emit(RewardError('Cập nhật khen thưởng thất bại'));
    }
  }

  Future<void> _onDeleteReward(
      DeleteReward event, Emitter<RewardState> emit) async {
    try {
      await repository.deleteReward(event.rewardId);
      emit(RewardSuccess());
      add(LoadRewards());
    } catch (e) {
      emit(RewardError('Xóa khen thưởng thất bại'));
    }
  }
}

import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardService {
  final CollectionReference _rewardCollection =
      FirebaseFirestore.instance.collection('rewards');

  Future<void> createReward(RewardModel reward) async {
    final docRef = _rewardCollection.doc();
    final rewardWithId =
        reward.copyWith(id: docRef.id, rewardDate: DateTime.now());
    await docRef.set(rewardWithId.toMap());
  }

  Future<void> updateReward(RewardModel reward) async {
    await _rewardCollection.doc(reward.id).update(reward.toMap());
  }

  Future<void> deleteReward(String id) async {
    await _rewardCollection.doc(id).delete();
  }

  Future<RewardModel?> getRewardById(String id) async {
    final doc = await _rewardCollection.doc(id).get();
    if (doc.exists) {
      return RewardModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<RewardModel>> getAllReward() async {
    final snapshot = await _rewardCollection.get();
    return snapshot.docs
        .map((doc) => RewardModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<RewardModel>> getAllRewards() async {
    final snapshot =
        await _rewardCollection.orderBy('rewardDate', descending: true).get();
    return snapshot.docs
        .map((doc) => RewardModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<RewardModel>> streamAllRewards() {
    return _rewardCollection
        .orderBy('rewardDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                RewardModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}

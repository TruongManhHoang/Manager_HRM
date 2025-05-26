import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<List<AccountModel>> getAllAccounts() async {
    try {
      final snapshot = await _collectionReference.get();
      return snapshot.docs
          .map((doc) =>
              AccountModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String password, String userId) async {
    try {
      await _collectionReference.doc(userId).update({'password': password});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addAccount(AccountModel account) async {
    try {
      final docRef = _collectionReference.doc();
      final accountWithId = account.copyWith(
          id: docRef.id, createdAt: DateTime.now(), updatedAt: DateTime.now());
      await docRef.set(accountWithId.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAccount(AccountModel account) async {
    try {
      await _collectionReference.doc(account.id).update(account.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String accountId) async {
    try {
      await _collectionReference.doc(accountId).delete();
    } catch (e) {
      rethrow;
    }
  }
}

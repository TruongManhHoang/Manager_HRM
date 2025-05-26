import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp({
    // required String email,
    // required String password,
    // required String displayName,
    AccountModel? accountModel,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: accountModel!.email,
      password: accountModel.password,
    );

    final user = userCredential.user!;
    final uid = user.uid;

    try {
      // 🔄 Cập nhật profile trong FirebaseAuth
      await user.updateDisplayName(accountModel.name);
      await user.reload(); // Cập nhật lại local user info

      // 🔥 Lưu vào Firestore
      await _firestore.collection('users').doc(uid).set({
        'id': uid,
        'code': accountModel.code,
        'email': accountModel.email,
        'password': accountModel.password,
        'employeeId': accountModel.employeeId,
        'name': accountModel.name,
        'status': accountModel.status,
        'role': 'user',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print("🔥 Firestore set error: $e");
      rethrow;
    }

    return FirebaseAuth.instance.currentUser == null
        ? userCredential
        : await _auth.signInWithEmailAndPassword(
            email: accountModel.email, password: accountModel.password);
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> deleteUserByUid(String uid) async {
    debugPrint("🔥 deleteUserByUid: $uid");
    final callable =
        FirebaseFunctions.instance.httpsCallable('deleteUserByUid');
    try {
      final result = await callable.call(<String, dynamic>{'uid': uid});
      print(result.data['message']);
    } on FirebaseFunctionsException catch (e) {
      print('Firebase Functions error: ${e.code} - ${e.message}');
    } catch (e) {
      print('Lỗi khác: $e');
    }
  }

  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception("No user is currently signed in.");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user != null) {
      final tokenResult = await user.getIdTokenResult(true);
      return tokenResult.claims?['admin'] == true;
    }
    return false;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

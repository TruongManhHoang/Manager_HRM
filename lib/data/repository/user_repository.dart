import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AccountModel> fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Người dùng chưa đăng nhập");

    final tokenResult = await user.getIdTokenResult(true);
    final token = tokenResult.token ?? '';

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) throw Exception("Không tìm thấy thông tin người dùng");

    return AccountModel.fromJson(userDoc.data()!);
  }

  Future<PersionalManagement> fetchPersonalProfile(String personalId) async {
    final result =
        await _firestore.collection('personnel').doc(personalId).get();
    if (!result.exists) throw Exception("Không tìm thấy thông tin employee");
    return PersionalManagement.fromJson(result.data()!);
  }
}

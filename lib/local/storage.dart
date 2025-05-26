import 'package:admin_hrm/data/model/user_model.dart';
import 'package:hive/hive.dart';

// class StorageLocal {
//   static const String _userBox = 'userBox';
//   static const String _userDataKey = 'userData';

//   static Future<void> saveUser(AppUser user) async {
//     final box = await Hive.openBox(_userBox);
//     await box.put(_userDataKey, user.toMap());
//   }

//   static Future<AppUser?> getUser() async {
//     final box = await Hive.openBox(_userBox);
//     final data = box.get(_userDataKey);
//     if (data != null && data is Map<String, dynamic>) {
//       return AppUser.fromMap(data, uid: data['uid'], token: data['token']);
//     }
//     return null;
//   }

//   static Future<void> clearUser() async {
//     final box = await Hive.openBox(_userBox);
//     await box.clear();
//   }
// }

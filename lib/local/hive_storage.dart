import 'dart:ui';

import 'package:admin_hrm/data/model/attendance/attendance_model.dart';
import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:admin_hrm/data/model/kpi/kpi_model.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GlobalStorageKey {
  const GlobalStorageKey._();

  static const globalStorage = 'globalStorage';
  static const userId = 'user_id';
  static const displayName = 'display_name';
  static const accessToken = 'access_token';
  static const isLoggedIn = 'is_logged_in';
  static const isDarkMode = 'isDarkMode';
  static const languageCode = 'languageCode';
  static const role = 'role';
  static const userData = 'userData';
  static const positions = "positions";
  static const departments = "departments";
  static const personalManagers = "personalManagers";
  static const attendances = "attendances";
  static const contracts = "contracts";
  static const rewards = "rewards";
  static const disciplinarys = "disciplinaryActions";
  static const kpis = "kpis";
  static const personalModel = "personalModel";
  static const password = "password";
}

abstract class GlobalStorage {
  Future<void> init();

  PersionalManagement? get personalModel;
  Future<void> addPersonalModel(PersionalManagement personalModel);

  List<PositionModel>? get positions;
  Future<void> addToPosition(PositionModel position);
  Future<void> fetchAllPosition(List<PositionModel> positions);
  Future<void> updatePosition(PositionModel position);
  Future<void> removeFromPositionById(String id);
  Future<void> removeAllPosition();

  List<DepartmentModel>? get departments;
  Future<void> addToDepartment(DepartmentModel department);
  Future<void> fetchAllDepartment(List<DepartmentModel> departments);
  Future<void> updateDepartment(DepartmentModel department);
  Future<void> removeFromDepartmentById(String id);
  Future<void> removeAllDepartment();

  List<PersionalManagement>? get personalManagers;
  Future<void> addToPersonalManager(PersionalManagement manager);
  Future<void> fetchAllPersonalManagers(List<PersionalManagement> managers);
  Future<void> updatePersonalManager(PersionalManagement manager);
  Future<void> removeFromPersonalManagerById(String id);
  Future<void> removeAllPersonalManagers();

  List<AttendanceModel>? get attendances;
  Future<void> fetchAllAttendance(List<AttendanceModel> attendances);

  List<ContractModel>? get contracts;
  Future<void> fetchAllContracts(List<ContractModel> contracts);

  List<RewardModel>? get rewards;
  Future<void> fetchAllRewards(List<RewardModel> rewards);

  List<DisciplinaryModel>? get disciplinaryActions;
  Future<void> fetchAllDisciplinaryActions(List<DisciplinaryModel> actions);

  List<KPIModel>? get kpis;
  Future<void> fetchAllKpis(List<KPIModel> kpis);

  // New authentication methods
  String? get accessToken;

  String? get userId;

  String? get password;

  String? get displayName;

  String? get role;

  bool get isLoggedIn;

  Locale get languageCode;

  set languageCode(Locale languageCode);

  bool get darkMode;

  set darkMode(bool isDarkMode);

  Future<void> updateAuthenticationState({
    required String? displayName,
    required String? userId,
    required String? role,
    required String? password,
  });

  Future<void> clearAuthenticationState();

  Map<String, dynamic> get userData;

  set userData(dynamic data);
}

class GlobalStorageImpl implements GlobalStorage {
  late Box _box;

  @override
  Locale get languageCode {
    String lang = _box.get(GlobalStorageKey.languageCode, defaultValue: 'en');
    return Locale(lang);
  }

  @override
  set languageCode(Locale languageCode) {
    _box.put(GlobalStorageKey.languageCode, languageCode.languageCode);
  }

  @override
  Future<void> init() async {
    _box = await Hive.openBox('globalStorage');
  }

  @override
  String? get accessToken {
    return _box.get(GlobalStorageKey.accessToken);
  }

  @override
  String? get role {
    return _box.get(GlobalStorageKey.role);
  }

  @override
  String? get userId {
    return _box.get(GlobalStorageKey.userId);
  }

  @override
  bool get isLoggedIn {
    return _box.get(GlobalStorageKey.isLoggedIn, defaultValue: false);
  }

  @override
  bool get darkMode {
    return _box.get(GlobalStorageKey.isDarkMode, defaultValue: false);
  }

  @override
  set darkMode(bool isDarkMode) {
    _box.put(GlobalStorageKey.isDarkMode, isDarkMode);
  }

  @override
  Future<void> updateAuthenticationState({
    required String? displayName,
    required String? userId,
    required String? role,
    required String? password,
  }) async {
    if (displayName == null) {
      await clearAuthenticationState();
      return;
    }
    await Future.wait([
      _box.put(GlobalStorageKey.displayName, displayName),
      _box.put(GlobalStorageKey.userId, userId),
      _box.put(GlobalStorageKey.role, role),
      _box.put(GlobalStorageKey.password, password),
    ]);
    debugPrint("UpdateAuthentication: ${_box.get(GlobalStorageKey.role)} ");
  }

  @override
  Future<void> clearAuthenticationState() async {
    await Future.wait([
      _box.delete(GlobalStorageKey.personalModel),
      _box.delete(GlobalStorageKey.role),
      _box.delete(GlobalStorageKey.displayName),
      _box.delete(GlobalStorageKey.userId),
      _box.delete(GlobalStorageKey.password),
    ]);

    debugPrint(
        "Cleared authentication state: ${_box.get(GlobalStorageKey.displayName)} ${_box.get(GlobalStorageKey.role)}");
  }

  @override
  Map<String, dynamic> get userData {
    return _box.get(GlobalStorageKey.userData) ??
        {
          'accessToken': '',
          'refreshToken': '',
          'user': null,
        };
  }

  @override
  set userData(dynamic data) {
    _box.put(GlobalStorageKey.userData, data);
  }

  @override
  // TODO: implement departments
  List<DepartmentModel>? get departments {
    final jsonList = _box.get(GlobalStorageKey.departments, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) => DepartmentModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  Future<void> addToDepartment(DepartmentModel department) async {
    List<DepartmentModel> departmentList = departments!;
    departmentList.add(department);
    await _box.put(
        GlobalStorageKey.departments, departmentList.map((e) => e.toMap()));
    debugPrint(
      "Department list is ${_box.get(GlobalStorageKey.departments)}",
    );
  }

  @override
  Future<void> addToPosition(PositionModel position) async {
    List<PositionModel> positionList = positions!;
    positionList.add(position);
    await _box.put(
        GlobalStorageKey.positions, positionList.map((e) => e.toMap()));
    debugPrint(
      "Position list is ${_box.get(GlobalStorageKey.positions)}",
    );
  }

  @override
  List<PositionModel>? get positions {
    final jsonList = _box.get(GlobalStorageKey.positions, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) => PositionModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  Future<void> removeAllDepartment() {
    return _box.put(GlobalStorageKey.departments, []);
  }

  @override
  Future<void> removeAllPosition() {
    return _box.put(GlobalStorageKey.positions, []);
  }

  @override
  Future<void> removeFromDepartmentById(String id) async {
    List<DepartmentModel> departmentList = departments!;
    departmentList.removeWhere((department) => department.id == id);
    await _box.put(
        GlobalStorageKey.departments, departmentList.map((e) => e.toMap()));
    debugPrint(
      "Department list is ${_box.get(GlobalStorageKey.departments)}",
    );
  }

  @override
  Future<void> removeFromPositionById(String id) async {
    List<PositionModel> positionList = positions!;
    positionList.removeWhere((position) => position.id == id);
    await _box.put(
        GlobalStorageKey.positions, positionList.map((e) => e.toMap()));
    debugPrint(
      "Position list is ${_box.get(GlobalStorageKey.positions)}",
    );
  }

  @override
  String? get displayName => _box.get(GlobalStorageKey.displayName);

  @override
  Future<void> updateDepartment(DepartmentModel department) async {
    List<DepartmentModel> departmentList = departments ?? [];
    final index = departmentList.indexWhere((d) => d.id == department.id);
    if (index != -1) {
      departmentList[index] = department;
    } else {
      departmentList.add(department);
    }
    await _box.put(
      GlobalStorageKey.departments,
      departmentList.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Department list is ${_box.get(GlobalStorageKey.departments)}",
    );
  }

  @override
  Future<void> updatePosition(PositionModel position) async {
    List<PositionModel> positionList = positions ?? [];
    final index = positionList.indexWhere((p) => p.id == position.id);
    if (index != -1) {
      positionList[index] = position;
    } else {
      positionList.add(position);
    }
    await _box.put(
      GlobalStorageKey.positions,
      positionList.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Position list is ${_box.get(GlobalStorageKey.positions)}",
    );
  }

  @override
  Future<void> fetchAllDepartment(List<DepartmentModel> departments) async {
    await _box.put(
      GlobalStorageKey.departments,
      departments.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Department list is ${_box.get(GlobalStorageKey.departments)}",
    );
  }

  @override
  Future<void> fetchAllPosition(List<PositionModel> positions) async {
    await _box.put(
      GlobalStorageKey.positions,
      positions.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Position list is ${_box.get(GlobalStorageKey.positions)}",
    );
  }

  @override
  Future<void> addToPersonalManager(PersionalManagement manager) async {
    List<PersionalManagement> managerList = personalManagers ?? [];
    managerList.add(manager);
    await _box.put(
        GlobalStorageKey.personalManagers, managerList.map((e) => e.toMap()));
    debugPrint(
      "Personal manager list is ${_box.get(GlobalStorageKey.personalManagers)}",
    );
  }

  @override
  Future<void> fetchAllPersonalManagers(
      List<PersionalManagement> managers) async {
    await _box.put(
      GlobalStorageKey.personalManagers,
      managers.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Personal manager list is ${_box.get(GlobalStorageKey.personalManagers)}",
    );
  }

  @override
  List<PersionalManagement>? get personalManagers {
    final jsonList =
        _box.get(GlobalStorageKey.personalManagers, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) => PersionalManagement.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  Future<void> removeAllPersonalManagers() {
    return _box.put(GlobalStorageKey.personalManagers, []);
  }

  @override
  Future<void> removeFromPersonalManagerById(String id) async {
    List<PersionalManagement> managerList = personalManagers ?? [];
    managerList.removeWhere((manager) => manager.id == id);
    await _box.put(
        GlobalStorageKey.personalManagers, managerList.map((e) => e.toMap()));
    debugPrint(
      "Personal manager list is ${_box.get(GlobalStorageKey.personalManagers)}",
    );
  }

  @override
  Future<void> updatePersonalManager(PersionalManagement manager) async {
    List<PersionalManagement> managerList = personalManagers ?? [];
    final index = managerList.indexWhere((m) => m.id == manager.id);
    if (index != -1) {
      managerList[index] = manager;
    }
    await _box.put(
        GlobalStorageKey.personalManagers, managerList.map((e) => e.toMap()));
    debugPrint(
      "Personal manager list is ${_box.get(GlobalStorageKey.personalManagers)}",
    );
  }

  @override
  // TODO: implement attendances
  List<AttendanceModel>? get attendances {
    final jsonList = _box.get(GlobalStorageKey.attendances, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) => AttendanceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  Future<void> fetchAllAttendance(List<AttendanceModel> attendances) async {
    await _box.put(
      GlobalStorageKey.attendances,
      attendances.map((e) => e.toJson()).toList(),
    );
    debugPrint(
      "Attendance list is ${_box.get(GlobalStorageKey.attendances)}",
    );
  }

  @override
  // TODO: implement contracts
  List<ContractModel>? get contracts {
    final jsonList = _box.get(GlobalStorageKey.contracts, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) => ContractModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  List<DisciplinaryModel>? get disciplinaryActions {
    final jsonList = _box.get(GlobalStorageKey.disciplinarys, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) =>
              DisciplinaryModel.fromFirestore(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  Future<void> fetchAllContracts(List<ContractModel> contracts) async {
    await _box.put(
      GlobalStorageKey.contracts,
      contracts.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Contract list is ${_box.get(GlobalStorageKey.contracts)}",
    );
  }

  @override
  Future<void> fetchAllDisciplinaryActions(
      List<DisciplinaryModel> actions) async {
    await _box.put(
      GlobalStorageKey.disciplinarys,
      actions.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Disciplinary list is ${_box.get(GlobalStorageKey.disciplinarys)}",
    );
  }

  @override
  Future<void> fetchAllKpis(List<KPIModel> kpis) async {
    await _box.put(
      GlobalStorageKey.kpis,
      kpis.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "KPI list is ${_box.get(GlobalStorageKey.kpis)}",
    );
  }

  @override
  Future<void> fetchAllRewards(List<RewardModel> rewards) async {
    debugPrint("Rewards to save: ${rewards.length}");

    await _box.put(
      GlobalStorageKey.rewards,
      rewards.map((e) => e.toMap()).toList(),
    );
    debugPrint(
      "Reward list is ${_box.get(GlobalStorageKey.rewards)}",
    );
  }

  @override
  List<KPIModel>? get kpis {
    final jsonList = _box.get(GlobalStorageKey.kpis, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) => KPIModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  List<RewardModel>? get rewards {
    final jsonList = _box.get(GlobalStorageKey.rewards, defaultValue: []);
    if (jsonList is List) {
      return jsonList
          .map((e) => RewardModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  @override
  Future<void> addPersonalModel(PersionalManagement accountModel) async {
    await _box.put(GlobalStorageKey.personalModel, accountModel.toMap());
  }

  @override
  // TODO: implement personalModel
  PersionalManagement? get personalModel {
    final data = _box.get(GlobalStorageKey.personalModel);
    if (data != null) {
      if (data is Map<String, dynamic>) {
        return PersionalManagement.fromJson(data);
      } else if (data is Map) {
        return PersionalManagement.fromJson(Map<String, dynamic>.from(data));
      }
    }
    return null;
  }

  @override
  // TODO: implement password
  String? get password => _box.get(GlobalStorageKey.password);
}

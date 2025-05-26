class RewardModel {
  final String? id;
  final String employeeId;
  final String code;
  final String rewardType;
  final DateTime? rewardDate;
  final String reason;
  final int rewardValue;
  final String approvedBy;
  final String status;

  RewardModel({
    this.id,
    required this.employeeId,
    required this.rewardType,
    required this.code,
    this.rewardDate,
    required this.reason,
    required this.rewardValue,
    required this.approvedBy,
    required this.status,
  });

  factory RewardModel.fromMap(Map<String, dynamic> map) {
    return RewardModel(
      id: map['id'],
      employeeId: map['employeeId'],
      rewardType: map['rewardType'],
      code: map['code'],
      rewardDate:
          map['rewardDate'] != null ? DateTime.parse(map['rewardDate']) : null,
      reason: map['reason'],
      rewardValue: map['rewardValue'],
      approvedBy: map['approvedBy'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'rewardType': rewardType,
      'code': code,
      'rewardDate': rewardDate?.toIso8601String(),
      'reason': reason,
      'rewardValue': rewardValue,
      'approvedBy': approvedBy,
      'status': status,
    };
  }

  // Hàm copyWith giúp tạo bản sao mới của đối tượng với các thay đổi
  RewardModel copyWith({
    String? id,
    String? employeeId,
    String? code,
    String? rewardType,
    DateTime? rewardDate,
    String? reason,
    int? rewardValue,
    String? approvedBy,
    String? status,
    String? document,
  }) {
    return RewardModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      code: code ?? this.code,
      rewardType: rewardType ?? this.rewardType,
      rewardDate: rewardDate ?? this.rewardDate,
      reason: reason ?? this.reason,
      rewardValue: rewardValue ?? this.rewardValue,
      approvedBy: approvedBy ?? this.approvedBy,
      status: status ?? this.status,
    );
  }
}

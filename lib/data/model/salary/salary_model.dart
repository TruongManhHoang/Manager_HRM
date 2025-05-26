class SalaryModel {
  final String? id;
  final String? code;
  final String employeeId;
  final double baseSalary;
  final double kpiBonus;
  final double rewardBonus;
  final double disciplinaryDeduction;
  final double attendanceBonus;
  final String approvedBy;
  final double? totalSalary;
  final DateTime? payDate;

  SalaryModel({
    this.id,
    this.code,
    required this.employeeId,
    required this.baseSalary,
    required this.kpiBonus,
    required this.rewardBonus,
    required this.disciplinaryDeduction,
    required this.attendanceBonus,
    required this.approvedBy,
    required this.totalSalary,
    this.payDate,
  });
  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      id: json['id'] as String ?? '',
      employeeId: json['employeeId'] as String ?? '',
      code: json['code'] as String ?? '',
      baseSalary: (json['baseSalary'] as num).toDouble(),
      kpiBonus: (json['kpiBonus'] as num).toDouble(),
      rewardBonus: (json['rewardBonus'] as num).toDouble(),
      disciplinaryDeduction: (json['disciplinaryDeduction'] as num).toDouble(),
      attendanceBonus: (json['attendanceBonus'] as num).toDouble(),
      approvedBy: (json['approvedBy'] as String) ?? '',
      totalSalary: (json['totalSalary'] as num).toDouble(),
      payDate: DateTime.parse(json['payDate'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'code': code,
      'baseSalary': baseSalary,
      'kpiBonus': kpiBonus,
      'rewardBonus': rewardBonus,
      'disciplinaryDeduction': disciplinaryDeduction,
      'attendanceBonus': attendanceBonus,
      'approvedBy': approvedBy,
      'totalSalary': totalSalary,
      'payDate': payDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'code': code,
      'baseSalary': baseSalary,
      'kpiBonus': kpiBonus,
      'rewardBonus': rewardBonus,
      'disciplinaryDeduction': disciplinaryDeduction,
      'attendanceBonus': attendanceBonus,
      'approvedBy': approvedBy,
      'totalSalary': totalSalary,
      'payDate': payDate?.toIso8601String(),
    };
  }

  SalaryModel copyWith({
    String? id,
    String? employeeId,
    String? code,
    double? baseSalary,
    double? kpiBonus,
    double? rewardBonus,
    double? disciplinaryDeduction,
    double? attendanceBonus,
    double? totalSalary,
    String? approvedBy,
    DateTime? payDate,
  }) {
    return SalaryModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      code: code ?? this.code,
      baseSalary: baseSalary ?? this.baseSalary,
      kpiBonus: kpiBonus ?? this.kpiBonus,
      rewardBonus: rewardBonus ?? this.rewardBonus,
      disciplinaryDeduction:
          disciplinaryDeduction ?? this.disciplinaryDeduction,
      attendanceBonus: attendanceBonus ?? this.attendanceBonus,
      approvedBy: approvedBy ?? this.approvedBy,
      totalSalary: totalSalary ?? this.totalSalary,
      payDate: payDate ?? this.payDate,
    );
  }
}

class DisciplinaryModel {
  final String? id;
  final String employeeId;
  final String code;
  final String disciplinaryType;
  final int disciplinaryValue;
  final DateTime? disciplinaryDate;
  final String reason;
  final String severity;
  final String status;
  final String approvedBy;

  DisciplinaryModel({
    this.id,
    required this.employeeId,
    required this.code,
    required this.disciplinaryType,
    required this.disciplinaryValue,
    this.disciplinaryDate,
    required this.reason,
    required this.severity,
    required this.status,
    required this.approvedBy,
  });

  factory DisciplinaryModel.fromFirestore(Map<String, dynamic> map) {
    return DisciplinaryModel(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      code: map['code'] ?? '',
      disciplinaryType: map['disciplinaryType'] ?? '',
      disciplinaryValue: map['disciplinaryValue'] ?? 0,
      disciplinaryDate: map['disciplinaryDate'] != null
          ? DateTime.parse(map['disciplinaryDate'])
          : null,
      reason: map['reason'] ?? '',
      severity: map['severity'] ?? '',
      status: map['status'] ?? '',
      approvedBy: map['approveBy'] ?? '',
    );
  }

  // Chuyển đổi từ object sang dữ liệu để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'code': code,
      'disciplinaryType': disciplinaryType,
      'disciplinaryValue': disciplinaryValue,
      'disciplinaryDate': disciplinaryDate?.toIso8601String(),
      'reason': reason,
      'severity': severity,
      'status': status,
      'approveBy': approvedBy,
    };
  }

  // Hàm copyWith giúp tạo bản sao mới của đối tượng với các thay đổi
  DisciplinaryModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? disciplinaryType,
    String? code,
    int? disciplinaryValue,
    DateTime? disciplinaryDate,
    String? reason,
    String? severity,
    String? approvedBy,
    String? status,
    String? approveBy,
  }) {
    return DisciplinaryModel(
      id: id ?? this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      disciplinaryType: disciplinaryType ?? this.disciplinaryType,
      disciplinaryDate: disciplinaryDate ?? this.disciplinaryDate,
      reason: reason ?? this.reason,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      disciplinaryValue: disciplinaryValue ?? this.disciplinaryValue,
    );
  }
}

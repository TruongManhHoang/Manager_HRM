class Contract {
  final String contractId;
  final String employeeId;
  final String contractType;
  final DateTime startDate;
  final DateTime endDate;
  final num basicSalary;
  final DateTime createAt;

  Contract({
    required this.contractId,
    required this.employeeId,
    required this.contractType,
    required this.startDate,
    required this.endDate,
    required this.basicSalary,
    required this.createAt,
  });
}

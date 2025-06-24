class CodeGenerator {
  /// Tạo mã tự động tăng theo format [prefix][số thứ tự]
  ///
  /// [prefix]: Tiền tố (VD: BL, HT, KT, KL, KPI, HD)
  /// [existingCodes]: Danh sách các mã đã tồn tại
  ///
  /// Ví dụ: generateCode('BL', ['BL01', 'BL02']) => 'BL03'
  static String generateCode(String prefix, List<String> existingCodes) {
    if (existingCodes.isEmpty) {
      // Nếu chưa có mã nào, bắt đầu từ 01
      return '${prefix}01';
    }

    // Tìm số thứ tự lớn nhất
    int maxNumber = 0;
    for (var code in existingCodes) {
      if (code.startsWith(prefix) && code.length >= prefix.length + 2) {
        final numberPart =
            code.substring(prefix.length); // Lấy phần số sau prefix
        final number = int.tryParse(numberPart) ?? 0;
        if (number > maxNumber) {
          maxNumber = number;
        }
      }
    }

    // Tăng số lên 1 và format thành 2 chữ số
    final nextNumber = maxNumber + 1;
    return '$prefix${nextNumber.toString().padLeft(2, '0')}';
  }

  /// Các prefix mặc định cho từng module
  static const String salaryPrefix = 'BL'; // Bảng lương
  static const String contractPrefix = 'HD'; // Hợp đồng
  static const String rewardPrefix = 'KT'; // Khen thưởng
  static const String disciplinaryPrefix = 'KL'; // Kỷ luật
  static const String kpiPrefix = 'KPI'; // KPI
  static const String attendancePrefix = 'CC'; // Chấm công
  static const String accountPrefix = 'TK'; // Tài khoản
  static const String departmentPrefix = 'PB'; // Phòng ban
  static const String positionPrefix = 'CV'; // Chức vụ
}

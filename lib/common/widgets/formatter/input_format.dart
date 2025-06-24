import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Xử lý rỗng
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');

    // Lọc các ký tự không phải số
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse và format số
    final number = int.tryParse(newText);
    if (number == null) {
      return oldValue;
    } // Format với dấu phân cách hàng nghìn và ký hiệu ₫
    final formatter = NumberFormat('#,##0', 'vi_VN');
    final formattedText = '${formatter.format(number)} ₫';

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  // Helper method để lấy giá trị thô từ text đã format
  static double getRawValue(String formattedText) {
    if (formattedText.isEmpty) return 0.0;

    // Loại bỏ tất cả ký tự không phải số
    String cleanText = formattedText
        .replaceAll(' ₫', '')
        .replaceAll('₫', '')
        .replaceAll(' VND', '')
        .replaceAll('VND', '')
        .replaceAll(',', '')
        .replaceAll('.', '')
        .replaceAll(' ', '')
        .trim();

    // Debug print
    print('Original: "$formattedText" -> Clean: "$cleanText"');

    final result = double.tryParse(cleanText) ?? 0.0;
    print('Parsed result: $result');
    return result;
  }
}

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Xử lý rỗng
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');

    // Lọc các ký tự không phải số
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final number = int.parse(newText);
    final newString = _formatter.format(number);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandWonFormatter extends TextInputFormatter {
  static final _numberFormat = NumberFormat('#,##0');
  final String Function({required Object n}) formatter;

  ThousandWonFormatter(this.formatter);

  static int? parse(String text) {
    return int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      return TextEditingValue(text: '');
    }
    final number = int.tryParse(cleanText);

    if (number == null) {
      return oldValue;
    }

    final formattedText = _numberFormat.format(number);

    int newOffset = formattedText.length;
    if (oldValue.text.length < newValue.text.length &&
        newValue.text.contains(',')) {
      // Adjust cursor if commas were added
      int commaCount = ','.allMatches(formattedText).length;
      int oldCommaCount = ','.allMatches(oldValue.text).length;
      newOffset = newValue.selection.end + (commaCount - oldCommaCount);
    } else if (oldValue.text.length > newValue.text.length &&
        oldValue.text.contains(',')) {
      // Adjust cursor if commas were removed
      int commaCount = ','.allMatches(formattedText).length;
      int oldCommaCount = ','.allMatches(oldValue.text).length;
      newOffset = newValue.selection.end - (oldCommaCount - commaCount);
    }

    final formatted = formatter(n: formattedText);
    final offset = formatted.indexOf(formattedText);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset + newOffset),
    );
  }
}

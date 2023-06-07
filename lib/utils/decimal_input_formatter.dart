import 'package:flutter/services.dart';

double convertLastTwoDigitsToDecimal(String input) {
  // Remove any non-digit characters from the input
  String sanitizedInput = input.replaceAll(RegExp(r'[^0-9]'), '');

  if (sanitizedInput.length < 2) {
    return 0.0; // Return 0 if the input is too short
  }

  // Extract the last two digits
  String lastTwoDigits = sanitizedInput.substring(sanitizedInput.length - 2);
  String leadingDigit = sanitizedInput.substring(0, sanitizedInput.length - 2);

  return double.parse(leadingDigit) + double.parse(lastTwoDigits) / 100;
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the new raw input value without any formatting
    String rawValue = newValue.text.replaceAll('.', '');

    if (rawValue.isEmpty) {
      return newValue; // Return the same value if input is empty
    }

    double inputValue = double.parse(rawValue) / 100;

    // Format the input with two decimal places
    String formattedValue = inputValue.toStringAsFixed(2);

    // Prevent leading zeros from being displayed (e.g., 0.01 instead of 0.0100)
    if (inputValue < 1.0) {
      formattedValue = formattedValue.substring(1);
    }

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

import 'package:intl/intl.dart';

String convertedToMoneyFormat(double amount) {
  return NumberFormat.currency(
    symbol: '\$', // Symbol to be displayed
    decimalDigits: 0, // Number of decimal places
  ).format(amount);
}

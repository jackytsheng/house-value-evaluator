import 'package:intl/intl.dart';

String convertedToMoneyFormat(double amount, {int decimal = 0}) {
  return NumberFormat.currency(
    symbol: '\$', // Symbol to be displayed
    decimalDigits: decimal, // Number of decimal places
  ).format(amount);
}

import 'package:flutter/material.dart';
import 'package:house_evaluator/type.dart';
import 'package:intl/intl.dart';

class ElevatedCard extends StatelessWidget {
  const ElevatedCard({
    super.key,
    required this.address,
    required this.overallScore,
    required this.price,
    required this.propertyType,
  });

  final String address;
  final PropertyType propertyType;
  final Price price;
  final double overallScore;

  String convertedToMoneyFormat(double amount) {
    return NumberFormat.currency(
      symbol: '\$', // Symbol to be displayed
      decimalDigits: 0, // Number of decimal places
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  Text(address, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(overallScore.toStringAsFixed(2)),
                      Text(price.state == PriceState.estimated
                          ? 'Est ${convertedToMoneyFormat(price.amount)} AUD'
                          : 'Sold ${convertedToMoneyFormat(price.amount)} AUD')
                    ],
                  ),
                ]))));
  }
}

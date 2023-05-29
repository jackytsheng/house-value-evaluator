import 'package:flutter/material.dart';
import 'package:house_evaluator/type.dart';
import 'package:intl/intl.dart';

class HouseCard extends StatelessWidget {
  const HouseCard({
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

  IconData iconPicker(PropertyType type) {
    switch (type) {
      case PropertyType.house:
        return Icons.house_rounded;
      case PropertyType.townHouse:
        return Icons.holiday_village_rounded;
      case PropertyType.apartment:
        return Icons.apartment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Card(
          margin: const EdgeInsets.all(20),
          elevation: 4,
          // shadowColor: Colors.pink[400],
          shadowColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          child: Container(
              height: 120,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(address,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(overallScore.toStringAsFixed(2)),
                      Text(price.state == PriceState.estimated
                          ? 'Est ${convertedToMoneyFormat(price.amount)} AUD'
                          : 'Sold ${convertedToMoneyFormat(price.amount)} AUD')
                    ],
                  ),
                ],
              ))),
      Positioned(
          top: 10,
          left: 10,
          child: Icon(
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 30,
            iconPicker(propertyType),
          )),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:house_evaluator/components/color_scale_widget.dart';
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
    Widget getChip(PriceState priceState) {
      String labelText;
      Color color;
      switch (priceState) {
        case PriceState.estimated:
          labelText = "Est";
          color = Theme.of(context).colorScheme.primary;
        case PriceState.sold:
          labelText = "Sold";
          color = Theme.of(context).colorScheme.inversePrimary;
      }

      return Container(
          margin: EdgeInsets.only(right: 10),
          child: CircleAvatar(
              radius: 14,
              backgroundColor: color,
              child: Text(labelText,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))));
    }

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
                    children: <Widget>[
                      ColorScaleWidget(
                        value: 3,
                        minValue: 0,
                        minColor: Colors.pink.shade100,
                        maxValue: 10,
                        maxColor: Colors.blue.shade100,
                        child: Center(
                            child: Text(overallScore.toStringAsFixed(2))),
                      ),
                      const Spacer(),
                      getChip(price.state),
                      Text(
                        "${convertedToMoneyFormat(price.amount)} AUD",
                        style: TextStyle(),
                      ),
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

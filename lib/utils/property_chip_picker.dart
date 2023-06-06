import 'package:flutter/material.dart';
import 'package:property_evaluator/model/property.dart';

Widget getChip(BuildContext context, PriceState priceState) {
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
          radius: 11,
          backgroundColor: color,
          child: Text(labelText,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 8,
                  fontWeight: FontWeight.bold))));
}

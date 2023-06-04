import 'package:flutter/material.dart';
import 'package:house_evaluator/components/color_scale_widget.dart';
import 'package:house_evaluator/components/float_card.dart';
import 'package:house_evaluator/route/property_route.dart';
import 'package:house_evaluator/model/house_card.dart';
import 'package:house_evaluator/utils/currency_formatter.dart';

class HouseCard extends StatelessWidget {
  const HouseCard({
    super.key,
    required this.address,
    required this.overallScore,
    required this.price,
    required this.propertyType,
    this.isEditMode = false,
  });

  final String address;
  final PropertyType propertyType;
  final Price price;
  final double overallScore;
  final bool isEditMode;

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
              radius: 11,
              backgroundColor: color,
              child: Text(labelText,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 8,
                      fontWeight: FontWeight.bold))));
    }

    return ListTile(
        horizontalTitleGap: 0,
        leading: isEditMode
            ? Radio<String>(
                value: "first",
                groupValue: "first",
                onChanged: (value) {
                  print(value);
                })
            : null,
        trailing: null,
        contentPadding: EdgeInsets.all(0),
        title: Stack(children: <Widget>[
          FloatCard(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              onTapAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PropertyRoute(
                          propertyAction: PropertyAction.editProperty)),
                );
              },
              child: Container(
                  height: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: <Widget>[
                      Text(address,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          ColorScaleWidget(
                            value: overallScore,
                            minValue: 0,
                            minColor: Theme.of(context).colorScheme.onPrimary,
                            lightTextColor:
                                Theme.of(context).colorScheme.onSecondary,
                            maxValue: 10,
                            darkTextColor:
                                Theme.of(context).colorScheme.inverseSurface,
                            maxColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            child: Center(
                                child: Text(
                              overallScore.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                          ),
                          const Spacer(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(children: [
                                  getChip(price.state),
                                  Text(
                                    "${convertedToMoneyFormat(price.amount)} AUD",
                                    style: TextStyle(
                                      fontFamily: "RobotoMono",
                                    ),
                                  ),
                                ]),
                                Text(
                                    "Unit Price: ${convertedToMoneyFormat(price.amount / overallScore)} AUD",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily: "RobotoMono",
                                    ))
                              ])
                        ],
                      ),
                    ],
                  ))),
          Positioned(
              left: 10,
              child: Icon(
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 30,
                iconPicker(propertyType),
              )),
        ]));
  }
}

import 'package:flutter/material.dart';
import 'package:property_evaluator/components/color_scale_widget.dart';
import 'package:property_evaluator/components/float_card.dart';
import 'package:property_evaluator/constants/route.dart';
import 'package:property_evaluator/route/property_route.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:property_evaluator/utils/currency_formatter.dart';
import 'package:property_evaluator/utils/icon_picker.dart';
import 'package:property_evaluator/utils/property_chip_picker.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.isEditMode = false,
  });

  final PropertyEntity property;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    final overAllScore = property.getOverAllScore();
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
        contentPadding: const EdgeInsets.all(0),
        title: Stack(children: <Widget>[
          FloatCard(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              onTapAction: () {
                Navigator.pushNamed(
                  context,
                  PROPERTY_ROUTE,
                  arguments: PropertyRouteArguments(
                      PropertyAction.editProperty, property),
                );
              },
              child: Container(
                  height: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: <Widget>[
                      Text(property.address,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          ColorScaleWidget(
                            value: overAllScore,
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
                              overAllScore.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                          ),
                          const Spacer(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(children: [
                                  getChip(context, property.price.state),
                                  Text(
                                    "${convertedToMoneyFormat(property.price.amount)} AUD",
                                    style: const TextStyle(
                                      fontFamily: "RobotoMono",
                                    ),
                                  ),
                                ]),
                                Text(
                                    overAllScore > 0
                                        ? "Unit Price: ${convertedToMoneyFormat(property.price.amount / overAllScore)} AUD / Score"
                                        : "Unit Price Not Available",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily: "RobotoMono",
                                    )),
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
                iconPicker(property.propertyType),
              )),
        ]));
  }
}

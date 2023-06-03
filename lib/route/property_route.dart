import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_evaluator/components/criteria_item.dart';
import 'package:house_evaluator/components/radial_score.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';
import 'package:house_evaluator/type.dart';
import 'package:house_evaluator/utils/currency_formatter.dart';
import 'package:intl/intl.dart';

const double COLUMN_GAP = 30;
const double WIDGET_INNER_WIDTH = 330;

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

class PropertyRoute extends StatefulWidget {
  const PropertyRoute(
      {super.key, this.propertyAction = PropertyAction.newProperty});

  final PropertyAction propertyAction;
  @override
  State<PropertyRoute> createState() => _PropertyRoute();
}

class _PropertyRoute extends State<PropertyRoute> {
  static const _locale = 'en';
  final _priceController = TextEditingController();
  String _formatNumber(String s) =>
      s != "" ? NumberFormat.decimalPattern(_locale).format(int.parse(s)) : "";

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  final List<bool> _selectedPropertyType = <bool>[false, false, true];
  final List<bool> _selectedPriceType = <bool>[false, true];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: ThemedAppBar(
              title: widget.propertyAction == PropertyAction.newProperty
                  ? "Add a new property"
                  : "Edit a property",
              helpMessage: "Tap to view score, hide legend available",
            ),
            body: SingleChildScrollView(
                child: Column(children: [
              const SizedBox(height: COLUMN_GAP),
              SizedBox(
                  width: WIDGET_INNER_WIDTH,
                  child: TextFormField(
                    maxLines: 2,
                    maxLength: 50,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Theme.of(context).colorScheme.inversePrimary,
                    decoration: InputDecoration(
                        label: Text("Address"),
                        alignLabelWithHint: true,
                        hintText: "Enter an address",
                        focusColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            borderRadius: BorderRadius.circular(24)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.black12),
                        )),
                  )),
              const SizedBox(height: 10),
              Center(
                  child: ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedPropertyType.length; i++) {
                      _selectedPropertyType[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                selectedColor: Theme.of(context).colorScheme.onInverseSurface,
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                color: Theme.of(context).colorScheme.inversePrimary,
                isSelected: _selectedPropertyType,
                children: <Widget>[
                  SizedBox(
                      width: 110,
                      child: Icon(Icons.apartment_rounded, size: 40)),
                  SizedBox(
                      width: 110, child: Icon(Icons.house_rounded, size: 40)),
                  SizedBox(
                      width: 110, child: Icon(Icons.villa_rounded, size: 40)),
                ],
              )),
              const SizedBox(height: 20),
              Center(
                  child: ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedPriceType.length; i++) {
                      _selectedPriceType[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                selectedColor: Theme.of(context).colorScheme.onInverseSurface,
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                color: Theme.of(context).colorScheme.inversePrimary,
                isSelected: _selectedPriceType,
                children: <Widget>[
                  SizedBox(
                      width: 165,
                      child: Text(
                        "Estimated",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                      width: 165,
                      child: Text(
                        "Sold",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ],
              )),
              const SizedBox(height: COLUMN_GAP),
              SizedBox(
                  width: WIDGET_INNER_WIDTH,
                  child: TextFormField(
                    cursorColor: Theme.of(context).colorScheme.inversePrimary,
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                    controller: _priceController,
                    style: TextStyle(fontFamily: "RobotoMono"),
                    onChanged: (string) {
                      string = '${_formatNumber(string.replaceAll(',', ''))}';
                      _priceController.value = TextEditingValue(
                        text: string,
                        selection:
                            TextSelection.collapsed(offset: string.length),
                      );
                    },
                    decoration: InputDecoration(
                        focusColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        label: Text("Price"),
                        prefix: Text("\$"),
                        suffix: Text("AUD"),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            borderRadius: BorderRadius.circular(24)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.black12),
                        )),
                  )),
              SizedBox(
                  width: WIDGET_INNER_WIDTH,
                  child: Column(children: [
                    Row(
                      children: <Widget>[
                        Text("Tax: ${convertedToMoneyFormat(2223)} AUD",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: "RobotoMono",
                            ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            "Additional cost: ${convertedToMoneyFormat(22223)} AUD",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: "RobotoMono",
                            ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            "Total cost: ${convertedToMoneyFormat(2222342323)} AUD",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: "RobotoMono",
                            ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            "Unit Price: ${convertedToMoneyFormat(22223)} AUD / pt",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: "RobotoMono",
                            ))
                      ],
                    )
                  ])),
              const SizedBox(height: COLUMN_GAP),
              const Divider(
                indent: 40,
                endIndent: 40,
              ),
              RadialScore(),
              CriteriaItem(criteriaReadOnly: true, criteriaName: "School"),
              CriteriaItem(),
              CriteriaItem(),
            ]))));
  }
}

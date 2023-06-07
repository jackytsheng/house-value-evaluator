import 'package:flutter/material.dart';
import 'package:property_evaluator/model/addition_cost.dart';
import 'package:property_evaluator/model/property.dart';

IconData propertyIconPicker(PropertyType type) {
  switch (type) {
    case PropertyType.house:
      return Icons.house_rounded;
    case PropertyType.townHouse:
      return Icons.holiday_village_rounded;
    case PropertyType.apartment:
      return Icons.apartment_rounded;
  }
}

IconData costIconPicker(CostType type) {
  switch (type) {
    case CostType.percentage:
      return Icons.percent_rounded;
    case CostType.plain:
      return Icons.monetization_on_rounded;
  }
}

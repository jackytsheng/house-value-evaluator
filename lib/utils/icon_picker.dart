import 'package:flutter/material.dart';
import 'package:property_evaluator/model/property.dart';

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

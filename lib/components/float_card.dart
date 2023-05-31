import 'package:flutter/material.dart';
import 'package:house_evaluator/route/property_route.dart';
import 'package:house_evaluator/type.dart';

class FlowCard extends StatelessWidget {
  FlowCard({super.key, required this.child, this.margin, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PropertyRoute(propertyAction: PropertyAction.editProperty)),
          );
        },
        child: Card(
            elevation: 4,
            margin: margin,
            shadowColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            child: Container(padding: padding, child: child)));
  }
}

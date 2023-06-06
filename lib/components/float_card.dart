import 'package:flutter/material.dart';
import 'package:property_evaluator/route/property_route.dart';
import 'package:property_evaluator/model/property.dart';

class FloatCard extends StatelessWidget {
  FloatCard(
      {super.key,
      required this.child,
      this.margin,
      this.padding,
      this.onTapAction});

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function()? onTapAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTapAction?.call();
        },
        child: Card(
            elevation: 4,
            margin: margin,
            shadowColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            child: Container(padding: padding, child: child)));
  }
}

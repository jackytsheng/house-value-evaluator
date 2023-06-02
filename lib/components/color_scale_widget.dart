import 'package:flutter/material.dart';

class ColorScaleWidget extends StatelessWidget {
  final double value;
  final double minValue;
  final Color minColor;
  final double maxValue;
  final Color maxColor;
  final Color lightTextColor;
  final Color darkTextColor;
  final Widget child;
  final double height;
  final double width;
  final double borderRadius;

  const ColorScaleWidget({
    Key? key,
    required this.value,
    required this.minValue,
    required this.minColor,
    required this.maxValue,
    required this.maxColor,
    required this.darkTextColor,
    required this.lightTextColor,
    required this.child,
    this.height = 40,
    this.width = 40,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage = (value - minValue) / (maxValue - minValue);
    final Color backgroundColor = Color.lerp(minColor, maxColor, percentage)!;
    final Color textColor = _getContrastingTextColor(backgroundColor);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      child: DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: child,
      ),
    );
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    final double luminance = (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    return luminance > 0.85 ? darkTextColor : lightTextColor;
  }
}

import 'package:flutter/material.dart';
import 'package:property_evaluator/components/help_icon_button.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final String helpMessage;

  const ThemedAppBar(
      {super.key, required this.title, required this.helpMessage})
      : preferredSize = const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 10,
      elevation: 10,
      actions: [HelpIconButton(helpMessage: helpMessage)],
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          );
        },
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}

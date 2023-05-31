import 'package:flutter/material.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';
import 'package:house_evaluator/type.dart';

class PropertyRoute extends StatelessWidget {
  PropertyRoute({super.key, this.propertyAction = PropertyAction.newProperty});

  final PropertyAction propertyAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: propertyAction == PropertyAction.newProperty
            ? "Add a new property"
            : "Edit a property",
        helpMessage: "",
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

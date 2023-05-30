import 'package:flutter/material.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';

class NewPropertyRoute extends StatelessWidget {
  const NewPropertyRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(
        title: "Add a new property",
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

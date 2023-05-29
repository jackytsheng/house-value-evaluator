import 'package:flutter/material.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';

class CompareRoute extends StatelessWidget {
  const CompareRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(title: "Comparison chart"),
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

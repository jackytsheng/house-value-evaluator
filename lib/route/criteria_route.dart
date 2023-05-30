import 'package:flutter/material.dart';
import 'package:house_evaluator/components/criteria_item.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';

class CriteriaRoute extends StatelessWidget {
  const CriteriaRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ThemedAppBar(
          title: "Criteria",
          helpMessage: "",
        ),
        body: Column(children: <Widget>[
          CriteriaItem(),
          CriteriaItem(),
          CriteriaItem()
        ]));
  }
}

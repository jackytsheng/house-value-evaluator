import 'package:flutter/material.dart';
import 'package:house_evaluator/components/cost_item.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';

import '../components/criteria_item.dart';

class AdditionalCostRoute extends StatelessWidget {
  const AdditionalCostRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: const ThemedAppBar(
              title: "Additional cost",
              helpMessage: """

        1. Swipe left to delete cost
        
        2. Percentage applied to the sold price

        3. Cost applied after percentage
        
        """,
            ),
            body: SingleChildScrollView(
                child: Column(children: <Widget>[
              CostItem(costItemType: CostType.amount),
              CostItem(costItemType: CostType.percentage),
            ])),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              shape: const CircleBorder(),
              tooltip: 'Add new criteria',
              child: Icon(Icons.post_add_rounded,
                  size: 30, color: Theme.of(context).colorScheme.onPrimary),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: BottomAppBar(
              height: 70,
              color: Theme.of(context).colorScheme.inversePrimary,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
            )));
  }
}

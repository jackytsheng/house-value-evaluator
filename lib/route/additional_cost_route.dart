import 'package:flutter/material.dart';
import 'package:property_evaluator/components/cost_item.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/model/addition_cost.dart';

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
        
1 TODO: swipe left to delete cost

2. Percentage applied to the sold price

3. Cost applied after percentage
        """,
            ),
            body: const SingleChildScrollView(
                child: Column(children: <Widget>[
              CostItem(costItemType: CostType.amount),
              CostItem(costItemType: CostType.percentage),
            ])),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              shape: const CircleBorder(),
              tooltip: 'Add new cost',
              child: Icon(Icons.add_card_rounded,
                  size: 30, color: Theme.of(context).colorScheme.onPrimary),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: BottomAppBar(
              height: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
            )));
  }
}

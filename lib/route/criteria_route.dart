import 'package:flutter/material.dart';
import 'package:house_evaluator/components/criteria_item.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';

class CriteriaRoute extends StatelessWidget {
  const CriteriaRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: const ThemedAppBar(
              title: "Criteria",
              helpMessage: """
        1. Swipe left to delete criteria
        
        2. Swipe up to choose weighting

        3. Weighting add up to 100%
        
        4. Criteria 15 characters max
        """,
            ),
            body: SingleChildScrollView(
                child: Column(children: <Widget>[
              CriteriaItem(),
              CriteriaItem(),
              CriteriaItem()
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
              height: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:property_evaluator/components/cost_item.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/model/addition_cost.dart';
import 'package:property_evaluator/utils/icon_picker.dart';

class AdditionalCostRoute extends StatelessWidget {
  const AdditionalCostRoute({
    super.key,
    required this.costItems,
    required this.setName,
    required this.setNumber,
    required this.deleteCost,
    required this.addCostItem,
  });

  final Function(String costItemId, double number) setNumber;
  final Function(String costItemId, String name) setName;
  final Function(String costItemId) deleteCost;
  final Function(CostType type) addCostItem;
  final List<AdditionalCostEntity> costItems;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: const ThemedAppBar(
              title: "Additional cost",
              helpMessage: """
1. Swipe left to delete cost

2. % cost applied to sold/est price

3. Plain cost added after %

4. Cost apply to all properties
        """,
            ),
            body: SingleChildScrollView(
              child: Column(
                  children: costItems
                      .map((item) => CostItem(
                            costItem: item,
                            setName: (name) => setName(item.costItemId, name),
                            deleteCost: () => deleteCost(item.costItemId),
                            setNumber: (number) =>
                                setNumber(item.costItemId, number),
                          ))
                      .toList()),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          addCostItem(CostType.percentage);
                        },
                        icon: Icon(costIconPicker(CostType.percentage)),
                        label: const Text("Add Cost")),
                    ElevatedButton.icon(
                        onPressed: () {
                          addCostItem(CostType.plain);
                        },
                        icon: Icon(costIconPicker(CostType.plain)),
                        label: const Text("Add Cost")),
                  ]),
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_evaluator/components/close_delete_dialog.dart';
import 'package:property_evaluator/model/addition_cost.dart';
import 'package:property_evaluator/utils/decimal_input_formatter.dart';

class CostItem extends StatelessWidget {
  const CostItem({
    super.key,
    required this.costItem,
    required this.setNumber,
    required this.setName,
    required this.deleteCost,
  });

  final Function(double number) setNumber;
  final Function(String name) setName;
  final Function() deleteCost;
  final AdditionalCostEntity costItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Slidable(
                  key: ValueKey(costItem.costItemId),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  child: CloseDeleteDialog(
                                      onDelete: deleteCost,
                                      children: [
                                        Text(
                                          "Are you sure you want delete this cost?",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        const SizedBox(height: 10)
                                      ])));
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        icon: Icons.delete,
                        spacing: 4,
                        label: 'Delete',
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(10)),
                      )
                    ],
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        maxLength: 15,
                        initialValue: costItem.costName,
                        onChanged: setName,
                        decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            labelText: "Cost",
                            hintText: "Enter Name"),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 120,
                      child: costItem.costType == CostType.percentage
                          ? TextFormField(
                              maxLength: 6,
                              initialValue: costItem.amount > 0
                                  ? costItem.amount.toStringAsFixed(2)
                                  : "",
                              onChanged: (value) =>
                                  setNumber(double.parse(value)),
                              inputFormatters: [DecimalTextInputFormatter()],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: ".00",
                                  labelText: "Percentage",
                                  suffixText: "%"),
                            )
                          : TextFormField(
                              maxLength: 7,
                              initialValue: costItem.amount > 0
                                  ? costItem.amount.toStringAsFixed(0)
                                  : "",
                              onChanged: (value) => {
                                value.isEmpty
                                    ? 0
                                    : setNumber(double.parse(value))
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                labelText: "Amount",
                                suffixText: "AUD",
                              ),
                            ),
                    ),
                  ]))),
          const SizedBox(height: 20),
          const Divider(
            indent: 40,
            endIndent: 40,
          )
        ]));
  }
}

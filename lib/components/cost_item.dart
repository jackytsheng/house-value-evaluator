import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_evaluator/components/accordion_note.dart';
import 'package:house_evaluator/model/addition_cost.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

class CostItem extends StatefulWidget {
  const CostItem(
      {super.key, required this.costItemType, this.costItemName = ""});

  final CostType costItemType;
  final String costItemName;

  @override
  State<CostItem> createState() => _CostItem();
}

class _CostItem extends State<CostItem> {
  final List<bool> _selectedCostType = <bool>[false, true];
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(
              height: 40,
              child: Center(
                  child: ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _selectedCostType.length; i++) {
                      _selectedCostType[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                selectedColor: Theme.of(context).colorScheme.onInverseSurface,
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                color: Theme.of(context).colorScheme.inversePrimary,
                isSelected: _selectedCostType,
                children: <Widget>[
                  SizedBox(
                      width: 155, child: Icon(Icons.percent_rounded, size: 30)),
                  SizedBox(
                      width: 155,
                      child: Icon(Icons.monetization_on_rounded, size: 30)),
                ],
              ))),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {}),
                    children: [
                      SlidableAction(
                        onPressed: null,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        icon: Icons.delete,
                        spacing: 4,
                        label: 'Delete',
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(10)),
                      )
                    ],
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        maxLength: 15,
                        initialValue: widget.costItemName,
                        decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            labelText: "Cost",
                            hintText: "Enter Name"),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 120,
                      // widget.costItemType == CostType.percentage ? 60 : 110,
                      child: TextFormField(
                        maxLength:
                            widget.costItemType == CostType.percentage ? 3 : 7,
                        initialValue: widget.costItemName,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          labelText: widget.costItemType == CostType.percentage
                              ? "Percentage"
                              : "Amount",
                          suffixText: widget.costItemType == CostType.percentage
                              ? "%"
                              : "AUD",
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

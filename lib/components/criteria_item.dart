import 'package:flutter/material.dart';
import 'package:house_evaluator/components/accordion_note.dart';
import 'package:house_evaluator/components/float_card.dart';
import 'package:numberpicker/numberpicker.dart';

class CriteriaItem extends StatelessWidget {
  const CriteriaItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: FlowCard(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              Row(children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Criteria",
                        hintText: "Enter Name"),
                  ),
                ),
                const Spacer(),
                Text(
                  "Weight: ",
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(16),
                      border: Border(
                          bottom: BorderSide(
                              width: 5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary))),
                  margin: EdgeInsets.only(right: 5),
                  child: NumberPicker(
                    itemWidth: 40,
                    itemHeight: 40,
                    haptics: true,
                    selectedTextStyle: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: "RobotoMono"),
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: "RobotoMono"),
                    value: 0,
                    itemCount: 1,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) => print(value),
                  ),
                ),
                Text(
                  "%",
                  style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                )
              ]),
              AccordionNote()
            ])));
  }
}

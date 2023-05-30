import 'package:flutter/material.dart';
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
            child: Row(children: [
              SizedBox(
                width: 200,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Criteria",
                      hintText: "Enter Name"),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: NumberPicker(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black38),
                  ),
                  haptics: true,
                  selectedTextStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "RobotoMono"),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  value: 2,
                  itemCount: 1,
                  minValue: 0,
                  maxValue: 100,
                  onChanged: (value) => print(value),
                ),
              )
            ])));
  }
}

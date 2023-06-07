import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_evaluator/components/criteria_item.dart';
import 'package:property_evaluator/components/radial_score.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:property_evaluator/utils/currency_formatter.dart';
import 'package:property_evaluator/utils/icon_picker.dart';

const double COLUMN_GAP = 30;
const double WIDGET_INNER_WIDTH = 330;

class PropertyRouteArguments {
  final PropertyEntity propertyEntity;
  final PropertyAction propertyAction;

  PropertyRouteArguments(this.propertyAction, this.propertyEntity);
}

class PropertyRoute extends StatelessWidget {
  const PropertyRoute({
    super.key,
    required this.setAddress,
    required this.setType,
    required this.setPrice,
    required this.setScore,
    required this.toggleExpand,
    required this.addNote,
    required this.setNoteHeader,
    required this.setNoteBody,
    required this.deleteNote,
  });

  final Function(String propertyId, String address) setAddress;
  final Function(String propertyId, PropertyType propertyType) setType;
  final Function(String propertyId, Price price) setPrice;
  final Function(String propertyId, String criteriaId, int score) setScore;
  final Function(String criteriaId, String noteId, bool isExpanded,
      Map<String, CriteriaItemEntity> criteriaMap) toggleExpand;
  final Function(String criteriaId, String noteId,
      Map<String, CriteriaItemEntity> criteriaMap) deleteNote;
  final Function(String criteriaId, NoteItem newNote,
      Map<String, CriteriaItemEntity> criteriaMap) addNote;
  final Function(String criteriaId, int noteIndex, String expandedValue,
      Map<String, CriteriaItemEntity> criteriaMap) setNoteBody;
  final Function(String criteriaId, int noteIndex, String headerValue,
      Map<String, CriteriaItemEntity> criteriaMap) setNoteHeader;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PropertyRouteArguments;

    final assessmentMap = args.propertyEntity.propertyAssessmentMap;
    final assessments =
        args.propertyEntity.propertyAssessmentMap.values.toList();

    double _getTotalScore() => assessments.fold(
        0, (acc, assessment) => acc + assessment.score * assessment.weighting);
    final List<double> mockCost = [111, 2222];
    double _getTotalCost() => mockCost.fold(
        args.propertyEntity.price.amount, (pre, current) => pre + current);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: ThemedAppBar(
            title: args.propertyAction == PropertyAction.newProperty
                ? "Add a new property"
                : "Edit a property",
            helpMessage: """
1. Legend list can be scrolled

2. Click legend to toggle visibility

3. Number can be swipe up or down

4. Click a track to view score

5. Total Score = sum(Weight * Score)
            """,
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            const SizedBox(height: COLUMN_GAP),
            SizedBox(
                width: WIDGET_INNER_WIDTH,
                child: TextFormField(
                  maxLines: 2,
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  initialValue: args.propertyEntity.address,
                  onChanged: (address) =>
                      setAddress(args.propertyEntity.propertyId, address),
                  decoration: InputDecoration(
                      label: const Text("Address"),
                      alignLabelWithHint: true,
                      hintText: "Enter an address",
                      focusColor: Theme.of(context).colorScheme.inversePrimary,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          borderRadius: BorderRadius.circular(24)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.black12),
                      )),
                )),
            const SizedBox(height: 10),
            Center(
                child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setType(
                    args.propertyEntity.propertyId, PropertyType.values[index]);
              },
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              selectedColor: Theme.of(context).colorScheme.onInverseSurface,
              fillColor: Theme.of(context).colorScheme.inversePrimary,
              color: Theme.of(context).colorScheme.inversePrimary,
              isSelected: PropertyType.values
                  .map((type) => type == args.propertyEntity.propertyType)
                  .toList(),
              children: PropertyType.values
                  .map((type) => SizedBox(
                      width: 110, child: Icon(iconPicker(type), size: 40)))
                  .toList(),
            )),
            const SizedBox(height: 20),
            Center(
                child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setPrice(
                    args.propertyEntity.propertyId,
                    Price(PriceState.values[index],
                        args.propertyEntity.price.amount));
              },
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              selectedColor: Theme.of(context).colorScheme.onInverseSurface,
              fillColor: Theme.of(context).colorScheme.inversePrimary,
              color: Theme.of(context).colorScheme.inversePrimary,
              isSelected: PriceState.values
                  .map((state) => state == args.propertyEntity.price.state)
                  .toList(),
              children: PriceState.values
                  .map((state) => SizedBox(
                      width: 165,
                      child: Text(
                        state.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )))
                  .toList(),
            )),
            const SizedBox(height: COLUMN_GAP),
            SizedBox(
                width: WIDGET_INNER_WIDTH,
                child: TextFormField(
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  style: const TextStyle(fontFamily: "RobotoMono"),
                  initialValue:
                      args.propertyEntity.price.amount.toStringAsFixed(0),
                  onChanged: (value) {
                    setPrice(
                        args.propertyEntity.propertyId,
                        Price(args.propertyEntity.price.state,
                            double.parse(value)));
                  },
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.inversePrimary,
                      label: const Text("Price"),
                      prefix: const Text("\$"),
                      suffix: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("AUD")),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          borderRadius: BorderRadius.circular(24)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.black12),
                      )),
                )),
            SizedBox(
                width: WIDGET_INNER_WIDTH,
                child: Column(children: [
                  Row(
                    children: <Widget>[
                      Text("Tax: ${convertedToMoneyFormat(2223)} AUD",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "RobotoMono",
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                          "Additional cost: ${convertedToMoneyFormat(22223)} AUD",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "RobotoMono",
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                          "Total cost: ${convertedToMoneyFormat(_getTotalCost())} AUD",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "RobotoMono",
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                          _getTotalScore() > 0
                              ? "Unit Price: ${convertedToMoneyFormat(22223)} AUD / Score"
                              : "Unit Price Not Available For Zero Score",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "RobotoMono",
                          ))
                    ],
                  )
                ])),
            const SizedBox(height: COLUMN_GAP),
            const Divider(
              indent: 40,
              endIndent: 40,
            ),
            assessments.isNotEmpty
                ? RadialScore(
                    totalScore: _getTotalScore(),
                    propertyAssessments: assessments)
                : const SizedBox(),
            Column(
                children: assessments
                    .map<CriteriaItem>((assessment) => CriteriaItem(
                        fromPropertyRoute: true,
                        setNumber: (score) {
                          setScore(args.propertyEntity.propertyId,
                              assessment.criteriaId, score);
                        },
                        setNoteBody: (noteIndex, body) {
                          setNoteBody(assessment.criteriaId, noteIndex, body,
                              assessmentMap);
                        },
                        setNoteHeader: (noteIndex, header) {
                          setNoteHeader(assessment.criteriaId, noteIndex,
                              header, assessmentMap);
                        },
                        addNote: (note) {
                          addNote(assessment.criteriaId, note, assessmentMap);
                        },
                        deleteNote: (noteId) {
                          deleteNote(
                              assessment.criteriaId, noteId, assessmentMap);
                        },
                        toggleExpand: (noteId, isExpanded) {
                          toggleExpand(assessment.criteriaId, noteId,
                              isExpanded, assessmentMap);
                        },
                        item: CriteriaItemEntity(
                            assessment.criteriaId,
                            assessment.notes,
                            assessment.criteriaName,
                            assessment.score.toDouble())))
                    .toList())
          ])),
          bottomSheet: assessments.isEmpty
              ? Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Create at least one criteria !",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )))
              : null,
        ));
  }
}

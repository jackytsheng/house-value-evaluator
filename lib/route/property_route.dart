import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_evaluator/components/criteria_item.dart';
import 'package:property_evaluator/components/radial_score.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/model/addition_cost.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/note.dart';
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
  const PropertyRoute(
      {super.key,
      required this.setAddress,
      required this.setType,
      required this.setPrice,
      required this.setScore,
      required this.toggleExpand,
      required this.addNote,
      required this.setNoteHeader,
      required this.setNoteBody,
      required this.deleteNote,
      required this.costItemsMap});

  final Function(String propertyId, String address) setAddress;
  final Function(String propertyId, PropertyType propertyType) setType;
  final Function(String propertyId, Price price) setPrice;
  final Function(String propertyId, String criteriaId, int score) setScore;
  final Function(String criteriaId, String noteId, bool isExpanded,
      Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty}) toggleExpand;
  final Function(String criteriaId, String noteId,
      Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty}) deleteNote;
  final Function(String criteriaId, NoteItem newNote,
      Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty}) addNote;
  final Function(String criteriaId, int noteIndex, String expandedValue,
      Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty}) setNoteBody;
  final Function(String criteriaId, int noteIndex, String headerValue,
      Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty}) setNoteHeader;
  final Map<String, AdditionalCostEntity> costItemsMap;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PropertyRouteArguments;

    final assessmentMap = args.propertyEntity.propertyAssessmentMap;
    final assessments =
        args.propertyEntity.propertyAssessmentMap.values.toList();

    double totalScore = assessments.fold(
        0, (acc, assessment) => acc + assessment.score * assessment.weighting);

    Map<CostType, List<AdditionalCostEntity>> getAdditionalCostByType() {
      var costMap = {
        CostType.plain: <AdditionalCostEntity>[],
        CostType.percentage: <AdditionalCostEntity>[]
      };
      for (var item in costItemsMap.values) {
        costMap[item.costType]?.add(item);
      }
      return costMap;
    }

    var costMap = getAdditionalCostByType();

    double totalPercentageCost = (1 +
            (costMap[CostType.percentage]!.fold(
                    0.0,
                    (previousValue, costItem) =>
                        costItem.amount + previousValue) /
                100)) *
        args.propertyEntity.price.amount;
    double totalPlainCost = costMap[CostType.plain]!.fold(
        0.0, (previousValue, costItem) => costItem.amount + previousValue);
    double totalCost = totalPlainCost + totalPercentageCost;

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: ThemedAppBar(
              title: args.propertyAction == PropertyAction.newProperty
                  ? "Add a new property"
                  : "Edit a property",
              childrenMessages: [
                Text("1. Score can be swiped up and down",
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                Text("2. Click legend label to change visibility of data",
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                Text("3. Property names can be scrolled vertically",
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                Text("4. Each track can be clicked to show score",
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                Text("5. Total Score = sum(Criteria Weight * Individual Score)",
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
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
                      width: 110,
                      child: Icon(propertyIconPicker(type), size: 40)))
                  .toList(),
            )),
            const SizedBox(height: 20),
            Center(
                child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setPrice(
                    args.propertyEntity.propertyId,
                    Price(
                        state: PriceState.values[index],
                        amount: args.propertyEntity.price.amount));
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
                  enableInteractiveSelection: false,
                  maxLength: 13,
                  style: const TextStyle(fontFamily: "RobotoMono"),
                  initialValue: args.propertyEntity.price.amount > 0
                      ? args.propertyEntity.price.amount.toStringAsFixed(0)
                      : "",
                  onChanged: (value) {
                    setPrice(
                        args.propertyEntity.propertyId,
                        Price(
                            state: args.propertyEntity.price.state,
                            amount:
                                value.isNotEmpty ? double.parse(value) : 0));
                  },
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.inversePrimary,
                      label: const Text("Price"),
                      prefix: const Text("\$"),
                      suffix: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("AUD")),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
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
            SizedBox(
                width: WIDGET_INNER_WIDTH,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...costMap[CostType.percentage]!.map((costItem) => Text(
                          "+ ${costItem.costName} : ${convertedToMoneyFormat(costItem.amount * args.propertyEntity.price.amount / 100, decimal: 2)} AUD",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "RobotoMono",
                          ))),
                      ...costMap[CostType.plain]!.map((costItem) => Text(
                          "+ ${costItem.costName}: ${convertedToMoneyFormat(costItem.amount)} AUD",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "RobotoMono",
                          ))),
                      totalCost > 0
                          ? Text(
                              "= Total Cost : ${convertedToMoneyFormat(totalCost)} AUD",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: "RobotoMono",
                              ))
                          : const SizedBox(),
                      Text(
                          totalScore > 0
                              ? "Total Cost / Score: ${convertedToMoneyFormat(totalCost / totalScore)} AUD"
                              : "Unit Price Not Available For Zero Score",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "RobotoMono",
                          ))
                    ])),
            const SizedBox(height: COLUMN_GAP),
            const Divider(
              indent: 40,
              endIndent: 40,
            ),
            assessments.isNotEmpty
                ? RadialScore(
                    totalScore: totalScore, propertyAssessments: assessments)
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
                              assessmentMap,
                              isCriteriaMapFromProperty: true);
                        },
                        setNoteHeader: (noteIndex, header) {
                          setNoteHeader(assessment.criteriaId, noteIndex,
                              header, assessmentMap,
                              isCriteriaMapFromProperty: true);
                        },
                        addNote: (note) {
                          addNote(assessment.criteriaId, note, assessmentMap,
                              isCriteriaMapFromProperty: true);
                        },
                        deleteNote: (noteId) {
                          deleteNote(
                              assessment.criteriaId, noteId, assessmentMap,
                              isCriteriaMapFromProperty: true);
                        },
                        toggleExpand: (noteId, isExpanded) {
                          toggleExpand(assessment.criteriaId, noteId,
                              isExpanded, assessmentMap,
                              isCriteriaMapFromProperty: true);
                        },
                        item: CriteriaItemEntity(
                            criteriaId: assessment.criteriaId,
                            notes: assessment.notes,
                            criteriaName: assessment.criteriaName,
                            weighting: assessment.score.toDouble())))
                    .toList())
          ])),
          bottomSheet: assessments.isEmpty
              ? Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Create at least one criteria first !",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )))
              : null,
        ));
  }
}

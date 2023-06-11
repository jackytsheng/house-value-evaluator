import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:property_evaluator/model/addition_cost.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/note.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:property_evaluator/model/app_state.dart';
import 'package:uuid/uuid.dart';

class LocalJsonStorage {
  var conditionCriteria = CriteriaItemEntity(
      criteriaId: const Uuid().v4(),
      notes: [
        NoteItem(
            headerValue: "Description",
            expandedValue: "Assessment on interior design")
      ],
      criteriaName: "Condition",
      weighting: 0.25);
  var trafficCriteria = CriteriaItemEntity(
      criteriaId: const Uuid().v4(),
      criteriaName: "Transport",
      weighting: 0.25);
  var facilityCriteria = CriteriaItemEntity(
      criteriaId: const Uuid().v4(), criteriaName: "Facility", weighting: 0.25);
  var convenienceCriteria = CriteriaItemEntity(
      criteriaId: const Uuid().v4(),
      criteriaName: "Convenience",
      weighting: 0.25);

  List<CriteriaItemEntity> get _getInitialCriteriaList {
    return [
      conditionCriteria,
      trafficCriteria,
      facilityCriteria,
      convenienceCriteria
    ];
  }

  Future<Directory> get _directory async {
    return await getApplicationDocumentsDirectory();
  }

  Future<String> get _localPath async {
    final directory = await _directory;

    return directory.path;
  }

  Future<File> get _localCostJson async {
    final path = await _localPath;

    return File('$path/cost.json');
  }

  Future<File> get _localPropertyJson async {
    final path = await _localPath;

    return File('$path/properties.json');
  }

  Future<File> get _localCriteriaJson async {
    final path = await _localPath;

    return File('$path/criteria.json');
  }

  Future<File> get _localAppStateJson async {
    final path = await _localPath;

    return File('$path/app-state.json');
  }

  Future<void> listAllItemsInDirectory() async {
    developer.log("listing all files within app directory");
    // Get the application documents directory
    final directory = await _directory;

    // Get a list of all items (files and subdirectories) in the directory
    final itemList = directory.listSync();

    for (var item in itemList) {
      developer.log(item.path);
    }
  }

  Future<List<AdditionalCostEntity>> readCostListFromJson() async {
    try {
      final file = await _localCostJson;

      // Read the file
      final contents = await file.readAsString();

      // Parse the JSON and create a UserSettings object
      final jsonList = jsonDecode(contents) as List<dynamic>;

      return jsonList
          .map((json) => AdditionalCostEntity.fromJson(json))
          .toList();
    } catch (e) {
      // Error handling
      developer.log(
          'error occurred: $e, setting additional cost to be the default value');

      var stampDuty = AdditionalCostEntity(
          costItemId: const Uuid().v4(),
          costName: "Stamp Duty",
          costType: CostType.percentage,
          amount: 5.5);
      var renovateCost = AdditionalCostEntity(
          costItemId: const Uuid().v4(),
          costName: "Renovation",
          costType: CostType.plain,
          amount: 20000);

      return [stampDuty, renovateCost];
    }
  }

  Future<void> writeCostListToJson(List<AdditionalCostEntity> costList) async {
    try {
      final file = await _localCostJson;

      final jsonList =
          costList.map((costEntity) => costEntity.toJson()).toList();

      final jsonStr = jsonEncode(jsonList);
      await file.writeAsString(jsonStr);
    } catch (e) {
      // Error handling
      developer.log('error occurred during writing additional cost json: $e');
    }
  }

  Future<AppState> readAppStateFromJson() async {
    try {
      final file = await _localAppStateJson;

      // Read the file
      final contents = await file.readAsString();

      // Parse the JSON and create a UserSettings object
      final json = jsonDecode(contents);

      return AppState.fromJson(json);
    } catch (e) {
      // Error handling
      developer
          .log('error occurred: $e, setting app state to be the default value');

      return AppState();
    }
  }

  Future<void> deleteTmpFiles() async {
    try {
      final path = await _localPath;

      final file = File('$path/test.txt');
      // Read the file
      file.delete();
    } catch (e) {
      // Error handling
      developer.log('error occurred: $e');
    }
  }

  Future<void> writeAppStateToJson(AppState state) async {
    try {
      final file = await _localAppStateJson;

      final jsonStr = jsonEncode(state.toJson());
      await file.writeAsString(jsonStr);
    } catch (e) {
      // Error handling
      developer.log('error occurred during writing app state json: $e');
    }
  }

  Future<List<PropertyEntity>> readPropertiesListFromJson() async {
    try {
      final file = await _localPropertyJson;

      // Read the file
      final contents = await file.readAsString();

      // Parse the JSON and create a UserSettings object
      final jsonList = jsonDecode(contents) as List<dynamic>;

      return jsonList.map((json) => PropertyEntity.fromJson(json)).toList();
    } catch (e) {
      // Error handling
      developer.log(
          'error occurred: $e, setting properties to be the default value');

      var ran = Random(123456789);
      var initialHouse = PropertyEntity(
          propertyId: const Uuid().v4(),
          address: "36 Example Street, Brighton Bay",
          price: Price(state: PriceState.estimated, amount: 8850000),
          propertyType: PropertyType.house,
          propertyAssessmentMap: {
            for (var item in _getInitialCriteriaList)
              item.criteriaId: PropertyAssessment(
                  criteriaId: item.criteriaId,
                  criteriaName: item.criteriaName,
                  weighting: item.weighting,
                  score: ran.nextInt(10)),
          },
          isSelected: true);

      var initialTownHouse = PropertyEntity(
          propertyId: const Uuid().v4(),
          address: "1/12 Example Road, Toorak",
          price: Price(state: PriceState.sold, amount: 1850000),
          propertyType: PropertyType.townHouse,
          propertyAssessmentMap: {
            for (var item in _getInitialCriteriaList)
              item.criteriaId: PropertyAssessment(
                  criteriaId: item.criteriaId,
                  criteriaName: item.criteriaName,
                  weighting: item.weighting,
                  score: ran.nextInt(10))
          },
          isSelected: true);

      return [initialHouse, initialTownHouse];
    }
  }

  Future<void> writePropertiesListToJson(
      List<PropertyEntity> propertyList) async {
    try {
      final file = await _localPropertyJson;

      final jsonList =
          propertyList.map((property) => property.toJson()).toList();

      final jsonStr = jsonEncode(jsonList);
      await file.writeAsString(jsonStr);
    } catch (e) {
      // Error handling
      developer.log('error occurred during writing property json: $e');
    }
  }

  Future<List<CriteriaItemEntity>> readCriteriaListFromJson() async {
    try {
      final file = await _localCriteriaJson;

      // Read the file
      final contents = await file.readAsString();

      // Parse the JSON and create a UserSettings object
      final jsonList = jsonDecode(contents) as List<dynamic>;

      return jsonList.map((json) => CriteriaItemEntity.fromJson(json)).toList();
    } catch (e) {
      // Error handling
      developer.log(
          'error occurred: $e, setting criteria item to be the default value');

      return _getInitialCriteriaList;
    }
  }

  Future<void> writeCriteriaListToJson(
      List<CriteriaItemEntity> criteriaList) async {
    try {
      final file = await _localCriteriaJson;

      final jsonList =
          criteriaList.map((criteria) => criteria.toJson()).toList();

      final jsonStr = jsonEncode(jsonList);
      await file.writeAsString(jsonStr);
    } catch (e) {
      // Error handling
      developer.log('error occurred during writing criteria json: $e');
    }
  }
}

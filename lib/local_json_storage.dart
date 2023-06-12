import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:property_evaluator/model/addition_cost.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/note.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:property_evaluator/model/app_state.dart';
import 'package:share/share.dart';
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
      notes: [],
      weighting: 0.25);
  var facilityCriteria = CriteriaItemEntity(
      notes: [],
      criteriaId: const Uuid().v4(),
      criteriaName: "Facility",
      weighting: 0.25);
  var convenienceCriteria = CriteriaItemEntity(
      notes: [],
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

      final initialCostList = [stampDuty, renovateCost];
      await writeCostListToJson(initialCostList);

      return initialCostList;
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
      developer.log(
          'error occurred: $e, setting app state to be the default value. And saving it to file');

      final initialAppState = AppState();
      await writeAppStateToJson(initialAppState);

      return initialAppState;
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
          'error occurred: $e, setting properties to be the default value. And saving it to file');

      var ran = Random(123456789);
      var initialHouse = PropertyEntity(
          propertyId: const Uuid().v4(),
          address: "36 Example Street, Brighton Bay",
          price: Price(state: PriceState.estimated, amount: 8850000),
          propertyType: PropertyType.house,
          propertyAssessmentMap: {
            for (var item in _getInitialCriteriaList)
              item.criteriaId: PropertyAssessment(
                  notes: [],
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
                  notes: [],
                  criteriaId: item.criteriaId,
                  criteriaName: item.criteriaName,
                  weighting: item.weighting,
                  score: ran.nextInt(10))
          },
          isSelected: true);

      final initialProperties = [initialHouse, initialTownHouse];
      await writePropertiesListToJson(initialProperties);

      return initialProperties;
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
          'error occurred: $e, setting criteria item to be the default value. And saving it to file');
      final initialCriteriaList = _getInitialCriteriaList;
      await writeCriteriaListToJson(initialCriteriaList);

      return initialCriteriaList;
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

  Future<void> exportJson() async {
    try {
      developer.log('exporting json files !');
      final directory = await _directory;
      final fileList = Directory(directory.path).listSync();

      List<String> filePaths = [];

      for (var file in fileList) {
        if (file is File) {
          filePaths.add(file.path);
        }
      }
      await Share.shareFiles(filePaths);
    } catch (e) {
      developer.log('error occurs when trying to export file: $e');
    }
  }
}

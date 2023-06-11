import 'dart:developer' as developer;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_evaluator/constants/route.dart';
import 'package:property_evaluator/local_json_storage.dart';
import 'package:property_evaluator/model/addition_cost.dart';
import 'package:property_evaluator/model/app_state.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/note.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:property_evaluator/route/additional_cost_route.dart';
import 'package:property_evaluator/route/compare_route.dart';
import 'package:property_evaluator/route/criteria_route.dart';
import 'package:property_evaluator/route/home_route.dart';
import 'package:property_evaluator/route/property_route.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(PropertyEvaluatorApp(storage: LocalJsonStorage()));
}

class PropertyEvaluatorApp extends StatefulWidget {
  const PropertyEvaluatorApp({super.key, required this.storage});

  final LocalJsonStorage storage;

  @override
  State<PropertyEvaluatorApp> createState() => _PropertyEvaluatorApp();
}

class _PropertyEvaluatorApp extends State<PropertyEvaluatorApp> {
  // Stored State
  Map<String, CriteriaItemEntity> criteriaItemsMap = {};
  Map<String, PropertyEntity> propertiesMap = {};
  Map<String, AdditionalCostEntity> costItemsMap = {};

  // App State
  AppState appState = AppState();

  // Run time State
  List<String> selectedPropertyIds = [];

  @override
  void initState() {
    widget.storage.listAllItemsInDirectory();

    // Read state from file on loading
    widget.storage.readCostListFromJson().then((costList) {
      setState(() {
        _prepareCostItemsMap(costList);
      });
    });

    widget.storage.readCriteriaListFromJson().then((criteriaList) {
      setState(() {
        _prepareCriteriaItemsMap(criteriaList);
      });
    });

    widget.storage.readPropertiesListFromJson().then((properties) {
      setState(() {
        _preparePropertiesMap(properties);

        // filter all selected first then map its id to list
        selectedPropertyIds = _generateSelectedList(properties);
      });
    });

    widget.storage.readAppStateFromJson().then((state) {
      setState(() {
        appState = state;
      });
    });

    super.initState();
  }

  void _savePropertyToFileDebounced(List<PropertyEntity> properties) {
    EasyDebounce.debounce(
        'PropertyJsonWriter', const Duration(milliseconds: 1000), () {
      developer.log("saving ${properties.length} properties in file");
      widget.storage.writePropertiesListToJson(properties).then((value) {
        developer.log("successfully saving properties");
      });
    });
  }

  void _saveCriteriaToFileDebounced(List<CriteriaItemEntity> criteriaList) {
    EasyDebounce.debounce(
        'CriteriaJsonWriter', const Duration(milliseconds: 1000), () {
      developer.log("saving ${criteriaList.length} criteria in file");
      widget.storage.writeCriteriaListToJson(criteriaList).then((value) {
        developer.log("successfully saving criteria");
      });
    });
  }

  void _saveCostToFileDebounced(List<AdditionalCostEntity> costList) {
    EasyDebounce.debounce('CostJsonWriter', const Duration(milliseconds: 1000),
        () {
      developer.log("saving ${costList.length} cost in file");
      widget.storage.writeCostListToJson(costList).then((value) {
        developer.log("successfully saving cost");
      });
    });
  }

  void _saveAppStateFileDebounced(AppState currentState) {
    EasyDebounce.debounce(
        'AppStateJsonWriter', const Duration(milliseconds: 1000), () {
      developer.log("saving app state in file");
      widget.storage.writeAppStateToJson(currentState).then((value) {
        developer.log("successfully saving app state");
      });
    });
  }

  List<String> _generateSelectedList(List<PropertyEntity> properties) =>
      properties
          .where((property) => property.isSelected)
          .map((property) => property.propertyId)
          .toList();

  void _prepareCriteriaItemsMap(List<CriteriaItemEntity> criteriaList) {
    criteriaItemsMap = {
      for (var criteria in criteriaList) criteria.criteriaId: criteria
    };
  }

  void _preparePropertiesMap(List<PropertyEntity> properties) {
    propertiesMap = {
      for (var property in properties) property.propertyId: property
    };
  }

  void _prepareCostItemsMap(List<AdditionalCostEntity> costList) {
    costItemsMap = {for (var cost in costList) cost.costItemId: cost};
  }

  void toggleNoteExpandStatusFromCriteria(String criteriaId, String noteId,
      bool isExpanded, Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty = false}) {
    setState(() {
      for (var note in criteriaMap[criteriaId]!.notes) {
        if (note.noteId == noteId) {
          note.isExpanded = !isExpanded;
          developer.log(
              'toggling criteria Id : $criteriaId,note id: ${note.noteId}, is setting from $isExpanded to ${note.isExpanded}');
        } else {
          note.isExpanded = false;
        }
      }

      // Property Route will update the note using thi method as well
      if (isCriteriaMapFromProperty) {
        _savePropertyToFileDebounced(propertiesMap.values.toList());
      } else {
        _saveCriteriaToFileDebounced(criteriaMap.values.toList());
      }
    });
  }

  void deleteNoteFromCriteria(String criteriaId, String noteId,
      covariant Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty = false}) {
    setState(() {
      criteriaMap[criteriaId]
          ?.notes
          .removeWhere((NoteItem note) => note.noteId == noteId);
      developer.log(
          "removing note item with Id: $noteId from criteria Id : $criteriaId");

      // Property Route will update the note using thi method as well
      if (isCriteriaMapFromProperty) {
        _savePropertyToFileDebounced(propertiesMap.values.toList());
      } else {
        _saveCriteriaToFileDebounced(criteriaMap.values.toList());
      }
    });
  }

  void setNoteHeaderToCriteria(String criteriaId, int noteIndex,
      String headerValue, Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty = false}) {
    setState(() {
      criteriaMap[criteriaId]?.notes[noteIndex].headerValue = headerValue;
      developer.log(
          "setting header for note index: $noteIndex from criteria Id : $criteriaId");

      // Property Route will update the note using thi method as well

      if (isCriteriaMapFromProperty) {
        _savePropertyToFileDebounced(propertiesMap.values.toList());
      } else {
        _saveCriteriaToFileDebounced(criteriaMap.values.toList());
      }
    });
  }

  void setNoteExpandedValueToCriteria(String criteriaId, int noteIndex,
      String expandedValue, Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty = false}) {
    setState(() {
      criteriaMap[criteriaId]?.notes[noteIndex].expandedValue = expandedValue;
      developer.log(
          "setting expandedValue for note index: $noteIndex from criteria Id : $criteriaId");

      // Property Route will update the note using thi method as well
      if (isCriteriaMapFromProperty) {
        _savePropertyToFileDebounced(propertiesMap.values.toList());
      } else {
        _saveCriteriaToFileDebounced(criteriaMap.values.toList());
      }
    });
  }

  void addNoteToCriteria(String criteriaId, NoteItem newNote,
      Map<String, CriteriaItemEntity> criteriaMap,
      {bool isCriteriaMapFromProperty = false}) {
    setState(() {
      for (var note in criteriaMap[criteriaId]!.notes) {
        note.isExpanded = false;
      }
      criteriaMap[criteriaId]?.notes.add(newNote);
      developer.log(
          "adding new note with Id: ${newNote.noteId} to criteria Id : $criteriaId");

      // Property Route will update the note using thi method as well
      if (isCriteriaMapFromProperty) {
        _savePropertyToFileDebounced(propertiesMap.values.toList());
      } else {
        _saveCriteriaToFileDebounced(criteriaMap.values.toList());
      }
    });
  }

  void addCriteria() {
    setState(() {
      String newCriteriaId = const Uuid().v4();
      criteriaItemsMap[newCriteriaId] =
          CriteriaItemEntity(criteriaId: newCriteriaId);
      developer.log("adding new criteria with Id: $newCriteriaId");

      _addCriteriaToAllHouse(criteriaItemsMap[newCriteriaId]!);
      _saveCriteriaToFileDebounced(criteriaItemsMap.values.toList());
      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void deleteCriteria(String criteriaId) {
    setState(() {
      criteriaItemsMap.remove(criteriaId);
      developer.log("removing criteria with Id: $criteriaId");
      _removeCriteriaFromAllHouse(criteriaId);
      _saveCriteriaToFileDebounced(criteriaItemsMap.values.toList());
      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void setCriteriaName(String criteriaId, String criteriaName) {
    setState(() {
      criteriaItemsMap[criteriaId]?.criteriaName = criteriaName;
      developer
          .log("setting criteria with Id: $criteriaId to name : $criteriaName");

      _updateCriteriaFromAllHouse(criteriaItemsMap[criteriaId]!);
      _saveCriteriaToFileDebounced(criteriaItemsMap.values.toList());
    });
  }

  void setCriteriaWeighting(String criteriaId, int weightingValue) {
    setState(() {
      criteriaItemsMap[criteriaId]?.weighting = weightingValue / 100;
      developer.log(
          "setting criteria Id: $criteriaId weighting to $weightingValue %");

      _updateCriteriaFromAllHouse(criteriaItemsMap[criteriaId]!);
      _saveCriteriaToFileDebounced(criteriaItemsMap.values.toList());
    });
  }

  void _removeCriteriaFromAllHouse(String criteriaId) {
    setState(() {
      for (final house in propertiesMap.values) {
        house.propertyAssessmentMap.remove(criteriaId);
      }

      _savePropertyToFileDebounced(propertiesMap.values.toList());
      developer.log(
          "finish removing criteria with Id: $criteriaId from all the houses");
    });
  }

  void _updateCriteriaFromAllHouse(CriteriaItemEntity criteria) {
    setState(() {
      for (var house in propertiesMap.values) {
        house.propertyAssessmentMap[criteria.criteriaId]?.criteriaName =
            criteria.criteriaName;
        house.propertyAssessmentMap[criteria.criteriaId]?.weighting =
            criteria.weighting;
      }

      _savePropertyToFileDebounced(propertiesMap.values.toList());
      developer.log(
          "finish updating criteria with Id: ${criteria.criteriaId} to all the houses");
    });
  }

  void _addCriteriaToAllHouse(CriteriaItemEntity criteria) {
    setState(() {
      for (var house in propertiesMap.values) {
        house.propertyAssessmentMap[criteria.criteriaId] = PropertyAssessment(
            criteriaId: criteria.criteriaId,
            criteriaName: criteria.criteriaName,
            weighting: criteria.weighting);
      }

      _savePropertyToFileDebounced(propertiesMap.values.toList());
      developer.log(
          "finish adding criteria with Id: ${criteria.criteriaId} from all the houses");
    });
  }

  bool _showValidationError() =>
      criteriaItemsMap.values
          .toList()
          .fold<double>(0,
              (totalWeighting, item) => totalWeighting + item.weighting * 100)
          .toInt() !=
      100;

// --- Property Route Handlers ---
  void setPropertyAddress(String propertyId, String address) {
    setState(() {
      propertiesMap[propertyId]?.address = address;
      developer
          .log("setting property with Id: $propertyId to address : $address");

      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void setPropertyPrice(String propertyId, Price price) {
    setState(() {
      propertiesMap[propertyId]?.price = price;
      developer.log(
          "setting property with Id: $propertyId to price amount : ${price.state} ${price.amount}");

      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void setPropertyType(String propertyId, PropertyType propertyType) {
    setState(() {
      propertiesMap[propertyId]?.propertyType = propertyType;
      developer.log(
          "setting property with Id: $propertyId to be : ${propertyType.name}");

      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void addProperty(BuildContext context) async {
    setState(() {
      final newPropertyId = const Uuid().v4();
      PropertyEntity newProperty = PropertyEntity(
          propertyId: newPropertyId,
          price: Price(state: PriceState.sold, amount: 0),
          propertyAssessmentMap: {
            for (var item in criteriaItemsMap.values)
              item.criteriaId: PropertyAssessment(
                  criteriaId: item.criteriaId,
                  criteriaName: item.criteriaName,
                  weighting: item.weighting)
          });
      propertiesMap[newPropertyId] = newProperty;
      developer.log("adding new property with Id: $newPropertyId");

      Navigator.pushNamed(
        context,
        PROPERTY_ROUTE,
        arguments:
            PropertyRouteArguments(PropertyAction.newProperty, newProperty),
      );

      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void setPropertyAssessmentScore(
      String propertyId, String criteriaId, int score) {
    setState(() {
      propertiesMap[propertyId]?.propertyAssessmentMap[criteriaId]?.score =
          score;
      developer.log(
          "setting criteria Id: $criteriaId of property Id: $propertyId score to $score");

      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  // Additional Cost Route
  void setAdditionCostName(String costId, String name) {
    setState(() {
      costItemsMap[costId]?.costName = name;
      developer.log(
          "setting name of additional cost with Id: $costId to name : $name");

      _saveCostToFileDebounced(costItemsMap.values.toList());
    });
  }

  void setAdditionCostNumber(String costId, double number) {
    setState(() {
      costItemsMap[costId]?.amount = number;
      developer.log(
          "setting number of additional cost with Id: $costId to amount : ${number.toString()}");

      _saveCostToFileDebounced(costItemsMap.values.toList());
    });
  }

  void deleteAdditionCost(String costId) {
    setState(() {
      costItemsMap.remove(costId);
      developer.log("removing additional cost with Id: $costId");

      _saveCostToFileDebounced(costItemsMap.values.toList());
    });
  }

  void addAdditionalCost(CostType type) {
    setState(() {
      String newCostId = const Uuid().v4();
      costItemsMap[newCostId] =
          AdditionalCostEntity(costItemId: newCostId, costType: type);
      developer
          .log("adding new additional cost with Id: $newCostId and type $type");

      _saveCostToFileDebounced(costItemsMap.values.toList());
    });
  }

  // Main Route
  void toggleThemeMode() {
    setState(() {
      appState.preferredMode = appState.preferredMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

      developer.log("changing theme to ${appState.preferredMode}");
      _saveAppStateFileDebounced(appState);
    });
  }

  void togglePropertyEditMode() {
    setState(() {
      appState.isEditMode = !appState.isEditMode;

      developer.log("toggling property edit mode");
      _saveAppStateFileDebounced(appState);
    });
  }

  void togglePropertySelected(String propertyId) {
    setState(() {
      propertiesMap[propertyId]!.isSelected =
          !propertiesMap[propertyId]!.isSelected;
      selectedPropertyIds =
          _generateSelectedList(propertiesMap.values.toList());

      developer.log("toggling propertyId $propertyId to select state");
      _saveAppStateFileDebounced(appState);
      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void deleteAllSelectedPropertyInSelectedList() {
    setState(() {
      propertiesMap
          .removeWhere((key, value) => selectedPropertyIds.contains(key));

      selectedPropertyIds = [];
      appState.isEditMode = false;

      developer.log("removing all selected property Ids");
      _saveAppStateFileDebounced(appState);
      _savePropertyToFileDebounced(propertiesMap.values.toList());
    });
  }

  void exportFile() {
    //could add another save before exporting
    widget.storage
        .exportJson()
        .then((value) => developer.log("successfully export files"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Property Evaluator',
      theme: FlexThemeData.light(
          scheme: FlexScheme.blue,
          surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
          blendLevel: 5,
          keyColors: const FlexKeyColors(),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          typography: Typography.material2021(
              platform: TargetPlatform.iOS,
              colorScheme: Theme.of(context).colorScheme)),
      darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.blue,
          surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
          blendLevel: 12,
          keyColors: const FlexKeyColors(),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          typography: Typography.material2021(
              platform: TargetPlatform.iOS,
              colorScheme: Theme.of(context).colorScheme)),
      themeMode: appState.preferredMode,
      routes: {
        ADDITIONAL_COST_ROUTE: (context) => AdditionalCostRoute(
              costItems: costItemsMap.values.toList(),
              setName: setAdditionCostName,
              setNumber: setAdditionCostNumber,
              addCostItem: addAdditionalCost,
              deleteCost: deleteAdditionCost,
            ),
        PROPERTY_ROUTE: (context) => PropertyRoute(
            setAddress: setPropertyAddress,
            setPrice: setPropertyPrice,
            setType: setPropertyType,
            setScore: setPropertyAssessmentScore,
            toggleExpand: toggleNoteExpandStatusFromCriteria,
            deleteNote: deleteNoteFromCriteria,
            addNote: addNoteToCriteria,
            setNoteHeader: setNoteHeaderToCriteria,
            setNoteBody: setNoteExpandedValueToCriteria,
            costItemsMap: costItemsMap),
        CRITERIA_ROUTE: (context) => CriteriaRoute(
              toggleExpand: (criteriaId, noteId, isExpanded) {
                toggleNoteExpandStatusFromCriteria(
                    criteriaId, noteId, isExpanded, criteriaItemsMap);
              },
              deleteNote: (criteriaId, noteId) {
                deleteNoteFromCriteria(criteriaId, noteId, criteriaItemsMap);
              },
              addNote: (criteriaId, note) {
                addNoteToCriteria(criteriaId, note, criteriaItemsMap);
              },
              setNoteHeader: (criteriaId, index, value) {
                setNoteHeaderToCriteria(
                    criteriaId, index, value, criteriaItemsMap);
              },
              setNoteBody: (criteriaId, index, value) {
                setNoteExpandedValueToCriteria(
                    criteriaId, index, value, criteriaItemsMap);
              },
              addCriteria: addCriteria,
              deleteCriteria: deleteCriteria,
              setName: setCriteriaName,
              setWeighting: setCriteriaWeighting,
              criteriaItems: criteriaItemsMap.values.toList(),
              shouldShowWeightingValidationError: _showValidationError(),
            ),
        COMPARE_ROUTE: (context) => CompareRoute(
            criteriaItemsMap: criteriaItemsMap,
            selectedPropertyIds: selectedPropertyIds,
            propertiesMap: propertiesMap)
      },
      home: HomeRoute(
          toggleThemeMode: toggleThemeMode,
          currentThemeMode: appState.preferredMode,
          properties: propertiesMap.values.toList(),
          addProperty: addProperty,
          isEditMode: appState.isEditMode,
          toggleEditMode: togglePropertyEditMode,
          selectedPropertyIds: selectedPropertyIds,
          togglePropertySelect: togglePropertySelected,
          deleteAllSelected: deleteAllSelectedPropertyInSelectedList,
          export: exportFile),
    );
  }
}

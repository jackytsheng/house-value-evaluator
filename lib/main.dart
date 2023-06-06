import 'dart:developer' as developer;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_evaluator/constants/route.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:property_evaluator/route/criteria_route.dart';
import 'package:property_evaluator/route/home_route.dart';
import 'package:property_evaluator/route/property_route.dart';
import 'package:uuid/uuid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(HomeEvaluatorApp());
}

class HomeEvaluatorApp extends StatefulWidget {
  HomeEvaluatorApp({super.key});

  @override
  State<HomeEvaluatorApp> createState() => _HomeEvaluatorApp();
}

class _HomeEvaluatorApp extends State<HomeEvaluatorApp> {
  // Criteria Item State
  Color selectedThemeColor = Colors.blue.shade200;
  Map<String, CriteriaItemEntity> criteriaItemsMap = {};
  bool shouldShowWeightingValidationError = false;

  // Property Route State
  Map<String, PropertyEntity> propertiesMap = {};

  @override
  void initState() {
    String initialCriteriaId = Uuid().v4();
    criteriaItemsMap = {
      initialCriteriaId: CriteriaItemEntity(initialCriteriaId, [], "Score", 1)
    };

    // TODO: Delete this initial house;
    String initialHouseId = Uuid().v4();
    propertiesMap = {
      initialHouseId: PropertyEntity(
          initialHouseId,
          "36 Campbell Street, Glen Waverley",
          Price(PriceState.estimated, 1850000),
          PropertyType.house, {
        for (var item in criteriaItemsMap.values)
          item.criteriaId: PropertyAssessment(
              item.criteriaId, [], item.criteriaName, item.weighting, 0)
      })
    };

    super.initState();
  }

  void toggleNoteExpandStatusFromCriteria(String criteriaId, String noteId,
      bool isExpanded, Map<String, CriteriaItemEntity> criteriaMap) {
    setState(() {
      criteriaMap[criteriaId]?.notes.forEach((NoteItem note) {
        if (note.noteId == noteId) {
          note.isExpanded = !isExpanded;
          developer.log(
              'toggling criteria Id : ${criteriaId},note id: ${note.noteId}, is setting from ${isExpanded} to ${note.isExpanded}');
        } else {
          note.isExpanded = false;
        }
      });
    });
  }

  void deleteNoteFromCriteria(String criteriaId, String noteId,
      covariant Map<String, CriteriaItemEntity> criteriaMap) {
    setState(() {
      criteriaMap[criteriaId]
          ?.notes
          .removeWhere((NoteItem note) => note.noteId == noteId);
      developer.log(
          "removing note item with Id: ${noteId} from criteria Id : ${criteriaId}");
    });
  }

  void setNoteHeaderToCriteria(String criteriaId, int noteIndex,
      String headerValue, Map<String, CriteriaItemEntity> criteriaMap) {
    setState(() {
      criteriaMap[criteriaId]?.notes[noteIndex].headerValue = headerValue;
      developer.log(
          "setting header for note index: ${noteIndex} from criteria Id : ${criteriaId}");
    });
  }

  void setNoteExpandedValueToCriteria(String criteriaId, int noteIndex,
      String expandedValue, Map<String, CriteriaItemEntity> criteriaMap) {
    setState(() {
      criteriaMap[criteriaId]?.notes[noteIndex].expandedValue = expandedValue;
      developer.log(
          "setting expandedValue for note index: ${noteIndex} from criteria Id : ${criteriaId}");
    });
  }

  void addNoteToCriteria(String criteriaId, NoteItem newNote,
      Map<String, CriteriaItemEntity> criteriaMap) {
    setState(() {
      criteriaMap[criteriaId]?.notes.forEach((note) {
        note.isExpanded = false;
      });
      criteriaMap[criteriaId]?.notes.add(newNote);
      developer.log(
          "adding new note with Id: ${newNote.noteId} to criteria Id : ${criteriaId}");
    });
  }

  void addCriteria() {
    setState(() {
      String newCriteriaId = Uuid().v4();
      criteriaItemsMap[newCriteriaId] =
          CriteriaItemEntity(newCriteriaId, [], "", 0);
      _addCriteriaToAllHouse(criteriaItemsMap[newCriteriaId]!);
      developer.log("adding new criteria with Id: ${newCriteriaId}");
    });
  }

  void deleteCriteria(String criteriaId) {
    setState(() {
      criteriaItemsMap.remove(criteriaId);
      developer.log("removing criteria with Id: ${criteriaId}");
      _removeCriteriaFromAllHouse(criteriaId);
    });

    _validateWeightingSum();
  }

  void setCriteriaName(String criteriaId, String criteriaName) {
    setState(() {
      criteriaItemsMap[criteriaId]?.criteriaName = criteriaName;
      _updateCriteriaFromAllHouse(criteriaItemsMap[criteriaId]!);
      developer.log(
          "setting criteria with Id: ${criteriaId} to name : ${criteriaName}");
    });
  }

  void setCriteriaWeighting(String criteriaId, int weightingValue) {
    EasyDebounce.debounce(
        'NumberPickerWeightingDebouncer',
        Duration(milliseconds: 10),
        () => setState(() {
              criteriaItemsMap[criteriaId]?.weighting = weightingValue / 100;
              _updateCriteriaFromAllHouse(criteriaItemsMap[criteriaId]!);
              developer.log(
                  "setting criteria Id: ${criteriaId} weighting to ${weightingValue} %");
            }));
    _validateWeightingSum();
  }

  void _removeCriteriaFromAllHouse(String criteriaId) {
    for (final house in propertiesMap.values) {
      house.propertyAssessmentMap.remove(criteriaId);
    }

    developer.log(
        "finish removing criteria with Id: ${criteriaId} from all the houses");
  }

  void _updateCriteriaFromAllHouse(CriteriaItemEntity criteria) {
    for (var house in propertiesMap.values) {
      house.propertyAssessmentMap[criteria.criteriaId]?.criteriaName =
          criteria.criteriaName;
      house.propertyAssessmentMap[criteria.criteriaId]?.weighting =
          criteria.weighting;
    }

    developer.log(
        "finish updating criteria with Id: ${criteria.criteriaId} to all the houses");
  }

  void _addCriteriaToAllHouse(CriteriaItemEntity criteria) {
    for (var house in propertiesMap.values) {
      house.propertyAssessmentMap[criteria.criteriaId] = PropertyAssessment(
          criteria.criteriaId,
          [],
          criteria.criteriaName,
          criteria.weighting,
          0);
    }

    developer.log(
        "finish adding criteria with Id: ${criteria.criteriaId} from all the houses");
  }

  void _validateWeightingSum() {
    EasyDebounce.debounce(
        'WeightingValidator',
        Duration(milliseconds: 500),
        () => setState(() {
              double totalWeighting = criteriaItemsMap.values
                  .toList()
                  .fold<double>(
                      0,
                      (totalWeighting, item) =>
                          totalWeighting + item.weighting * 100);
              if (totalWeighting.toInt() != 100) {
                shouldShowWeightingValidationError = true;
                developer.log(
                    "total weighting value is ${totalWeighting} %, doesn't equal 100 %");
              } else {
                developer.log("total weighting value equals 100 %");
                shouldShowWeightingValidationError = false;
              }
            }));
  }

// --- Property Route Handlers ---
  void setPropertyAddress(String propertyId, String address) {
    setState(() {
      propertiesMap[propertyId]?.address = address;
      developer.log(
          "setting property with Id: ${propertyId} to address : ${address}");
    });
  }

  void setPropertyPrice(String propertyId, Price price) {
    setState(() {
      propertiesMap[propertyId]?.price = price;
      developer.log(
          "setting property with Id: ${propertyId} to price amount : ${price.state} ${price.amount}");
    });
  }

  void setPropertyType(String propertyId, PropertyType propertyType) {
    setState(() {
      propertiesMap[propertyId]?.propertyType = propertyType;
      developer.log(
          "setting property with Id: ${propertyId} to be : ${propertyType.name}");
    });
  }

  void addProperty(BuildContext context) {
    setState(() {
      String newPropertyId = Uuid().v4();
      PropertyEntity newProperty = PropertyEntity(
          newPropertyId, "", Price(PriceState.sold, 0), PropertyType.house, {
        for (var item in criteriaItemsMap.values)
          item.criteriaId: PropertyAssessment(
              item.criteriaId, [], item.criteriaName, item.weighting, 0)
      });
      propertiesMap[newPropertyId] = newProperty;
      developer.log("adding new property with Id: ${newPropertyId}");

      Navigator.pushNamed(
        context,
        PROPERTY_ROUTE,
        arguments:
            PropertyRouteArguments(PropertyAction.newProperty, newProperty),
      );
    });
  }

  void setPropertyAssessmentScore(
      String propertyId, String criteriaId, int score) {
    EasyDebounce.debounce(
        'NumberPickerScoreDebouncer',
        Duration(milliseconds: 10),
        () => setState(() {
              propertiesMap[propertyId]
                  ?.propertyAssessmentMap[criteriaId]
                  ?.score = score;
              developer.log(
                  "setting criteria Id: ${criteriaId} of property Id: ${propertyId} score to ${score}");
            }));
  }

  // Main Route
  void changeThemeColor(Color color) {
    setState(() {
      selectedThemeColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Evaluator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: selectedThemeColor),
        useMaterial3: true,
      ),
      routes: {
        PROPERTY_ROUTE: (context) => PropertyRoute(
            setAddress: setPropertyAddress,
            setPrice: setPropertyPrice,
            setType: setPropertyType,
            setScore: setPropertyAssessmentScore,
            toggleExpand: toggleNoteExpandStatusFromCriteria,
            deleteNote: deleteNoteFromCriteria,
            addNote: addNoteToCriteria,
            setNoteHeader: setNoteHeaderToCriteria,
            setNoteBody: setNoteExpandedValueToCriteria),
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
              shouldShowWeightingValidationError:
                  shouldShowWeightingValidationError,
            ),
      },
      home: HomeRoute(
        changeThemeColor: changeThemeColor,
        currentThemeColor: selectedThemeColor,
        properties: propertiesMap.values.toList(),
        addProperty: addProperty,
      ),
    );
  }
}

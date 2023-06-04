import 'dart:developer' as developer;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_evaluator/constants/route.dart';
import 'package:house_evaluator/model/criteria_item.dart';
import 'package:house_evaluator/route/criteria_route.dart';
import 'package:house_evaluator/route/home_route.dart';
import 'package:uuid/uuid.dart';

// Can't choose too big because it will ended up in a loop
const DEBOUNCED_MILLISECONDS = 10;
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
  Color selectedThemeColor = Colors.blue.shade200;
  Map<String, CriteriaItemEntity> criteriaItemsMap = {};
  bool shouldShowWeightingValidationError = false;

  @override
  void initState() {
    String initialScoreId = Uuid().v4();
    criteriaItemsMap = {
      initialScoreId: CriteriaItemEntity(initialScoreId, [], "Score", 1)
    };

    super.initState();
  }

  void toggleNoteExpandStatusFromCriteria(
      String criteriaId, String noteId, bool isExpanded) {
    setState(() {
      criteriaItemsMap[criteriaId]?.notes.forEach((NoteItem note) {
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

  void deleteNoteFromCriteria(String criteriaId, String noteId) {
    setState(() {
      criteriaItemsMap[criteriaId]
          ?.notes
          .removeWhere((NoteItem note) => note.noteId == noteId);
      developer.log(
          "removing note item with Id: ${noteId} from criteria Id : ${criteriaId}");
    });
  }

  void setNoteHeaderToCriteria(
      String criteriaId, int noteIndex, String headerValue) {
    setState(() {
      criteriaItemsMap[criteriaId]?.notes[noteIndex].headerValue = headerValue;
      developer.log(
          "setting header for note index: ${noteIndex} from criteria Id : ${criteriaId}");
    });
  }

  void setNoteExpandedValueToCriteria(
      String criteriaId, int noteIndex, String expandedValue) {
    setState(() {
      criteriaItemsMap[criteriaId]?.notes[noteIndex].expandedValue =
          expandedValue;
      developer.log(
          "setting expandedValue for note index: ${noteIndex} from criteria Id : ${criteriaId}");
    });
  }

  void addNoteToCriteria(String criteriaId, NoteItem newNote) {
    setState(() {
      criteriaItemsMap[criteriaId]?.notes.add(newNote);
      developer.log(
          "adding new note with Id: ${newNote.noteId} to criteria Id : ${criteriaId}");
    });
  }

  void addCriteria() {
    setState(() {
      String newCriteriaId = Uuid().v4();
      criteriaItemsMap[newCriteriaId] =
          CriteriaItemEntity(newCriteriaId, [], "", 0);
      developer.log("adding new criteria with Id: ${newCriteriaId}");
    });
  }

  void setCriteriaName(String criteriaId, String criteriaName) {
    setState(() {
      criteriaItemsMap[criteriaId]?.criteriaName = criteriaName;
      developer.log(
          "setting criteria with Id: ${criteriaId} to name : ${criteriaName}");
    });
  }

  void deleteCriteria(String criteriaId) {
    setState(() {
      criteriaItemsMap.remove(criteriaId);
      developer.log("removing criteria with Id: ${criteriaId}");
    });

    _validateWeightingSum();
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

  void setCriteriaWeighting(String criteriaId, int weightingValue) {
    EasyDebounce.debounce(
        'NumberPickerDebouncer',
        Duration(milliseconds: 10),
        () => setState(() {
              criteriaItemsMap[criteriaId]?.weighting = weightingValue / 100;
              developer.log(
                  "setting criteria Id: ${criteriaId} weighting to ${weightingValue} %");
            }));
    _validateWeightingSum();
  }

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
        CRITERIA_ROUTE: (context) => CriteriaRoute(
              toggleExpand: toggleNoteExpandStatusFromCriteria,
              deleteNote: deleteNoteFromCriteria,
              addNote: addNoteToCriteria,
              setNoteHeader: setNoteHeaderToCriteria,
              setNoteBody: setNoteExpandedValueToCriteria,
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
      ),
    );
  }
}

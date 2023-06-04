import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_evaluator/constants/route.dart';
import 'package:house_evaluator/model/criteria_item.dart';
import 'package:house_evaluator/route/criteria_route.dart';
import 'package:house_evaluator/route/home_route.dart';
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
  Color selectedThemeColor = Colors.blue.shade200;
  Map<String, CriteriaItemEntity> criteriaItemsMap = {};

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
          print(
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
      print(
          "removing note item with Id: ${noteId} from criteria Id : ${criteriaId}");
    });
  }

  void setNoteHeaderToCriteria(
      String criteriaId, int noteIndex, String headerValue) {
    setState(() {
      criteriaItemsMap[criteriaId]?.notes[noteIndex].headerValue = headerValue;
      print(
          "setting header for note index: ${noteIndex} from criteria Id : ${criteriaId}");
    });
  }

  void setNoteExpandedValueToCriteria(
      String criteriaId, int noteIndex, String expandedValue) {
    setState(() {
      criteriaItemsMap[criteriaId]?.notes[noteIndex].expandedValue =
          expandedValue;
      print(
          "setting expandedValue for note index: ${noteIndex} from criteria Id : ${criteriaId}");
    });
  }

  void addNoteToCriteria(String criteriaId, NoteItem newNote) {
    setState(() {
      criteriaItemsMap[criteriaId]?.notes.add(newNote);
      print(
          "adding new note with Id: ${newNote.noteId} to criteria Id : ${criteriaId}");
    });
  }

  void addCriteria() {
    String newCriteriaId = Uuid().v4();
    criteriaItemsMap[newCriteriaId] =
        CriteriaItemEntity(newCriteriaId, [], "", 0);
    print("adding new criteria with Id: ${newCriteriaId}");
  }

// TODO: set weighting , set criteria name;

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
            criteriaItems: criteriaItemsMap.values.toList()),
      },
      home: HomeRoute(
        changeThemeColor: changeThemeColor,
        currentThemeColor: selectedThemeColor,
      ),
    );
  }
}

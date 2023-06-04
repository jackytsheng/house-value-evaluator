import 'package:flutter/material.dart';
import 'package:house_evaluator/components/criteria_item.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';
import 'package:house_evaluator/model/criteria_item.dart';

class CriteriaRoute extends StatelessWidget {
  const CriteriaRoute({
    super.key,
    required this.criteriaItems,
    required this.toggleExpand,
    required this.deleteNote,
    required this.addNote,
    required this.setNoteBody,
    required this.setNoteHeader,
    required this.addCriteria,
  });

  final Function(String criteriaId, String noteId, bool isExpanded)
      toggleExpand;
  final Function(String criteriaId, String noteId) deleteNote;
  final Function(String criteriaId, NoteItem newNote) addNote;
  final Function(String criteriaId, int noteIndex, String expandedValue)
      setNoteBody;
  final Function(String criteriaId, int noteIndex, String headerValue)
      setNoteHeader;
  final Function() addCriteria;
  final List<CriteriaItemEntity> criteriaItems;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: const ThemedAppBar(
              title: "Criteria",
              helpMessage: """
        1. Swipe left to delete criteria
        
        2. Swipe up to choose weighting

        3. Weighting add up to 100%
        
        4. Criteria 15 characters max

        5. At least one criteria required
        """,
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: criteriaItems
                        .map<CriteriaItem>((criteriaItem) => CriteriaItem(
                              toggleExpand: toggleExpand,
                              deleteNote: deleteNote,
                              addNote: addNote,
                              setNoteHeader: setNoteHeader,
                              setNoteBody: setNoteBody,
                              item: criteriaItem,
                            ))
                        .toList())),
            floatingActionButton: FloatingActionButton(
              onPressed: addCriteria,
              shape: const CircleBorder(),
              tooltip: 'Add new criteria',
              child: Icon(Icons.post_add_rounded,
                  size: 30, color: Theme.of(context).colorScheme.onPrimary),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: BottomAppBar(
              height: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
            )));
  }
}

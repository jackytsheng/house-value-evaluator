import 'package:flutter/material.dart';
import 'package:property_evaluator/components/criteria_item.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/model/criteria.dart';

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
    required this.deleteCriteria,
    required this.setWeighting,
    required this.setName,
    required this.shouldShowWeightingValidationError,
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
  final Function(String criteriaId) deleteCriteria;
  final Function(String criteriaId, int weightingValue) setWeighting;
  final Function(String criteriaId, String criteriaName) setName;
  final List<CriteriaItemEntity> criteriaItems;
  final bool shouldShowWeightingValidationError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: const ThemedAppBar(
              title: "Criteria",
              helpMessage: """
1. Swipe left to delete a single criteria
        
2. ⚠️ Delete criteria remove all notes ⚠️

3. Number can be swipe up or down
        
4. Criteria can have 15 characters max

5. Criteria name can be changed
        """,
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: criteriaItems
                        .map<CriteriaItem>((criteriaItem) => CriteriaItem(
                            toggleExpand: (noteId, isExpanded) {
                              toggleExpand(
                                  criteriaItem.criteriaId, noteId, isExpanded);
                            },
                            deleteNote: (noteId) {
                              deleteNote(criteriaItem.criteriaId, noteId);
                            },
                            addNote: (note) {
                              addNote(criteriaItem.criteriaId, note);
                            },
                            setNoteHeader: ((noteIndex, headerValue) {
                              setNoteHeader(criteriaItem.criteriaId, noteIndex,
                                  headerValue);
                            }),
                            setNoteBody: (noteIndex, body) {
                              setNoteBody(
                                  criteriaItem.criteriaId, noteIndex, body);
                            },
                            setNumber: (score) {
                              setWeighting(criteriaItem.criteriaId, score);
                            },
                            deleteCriteria: () {
                              deleteCriteria(criteriaItem.criteriaId);
                            },
                            item: criteriaItem,
                            setName: (name) {
                              setName(criteriaItem.criteriaId, name);
                            }))
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
            bottomSheet: shouldShowWeightingValidationError
                ? Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    width: double.infinity,
                    child: Center(
                        child: Text(
                      criteriaItems.length == 0
                          ? "Create at least one criteria !"
                          : "Value does not add up to 100% !",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )))
                : null,
            bottomNavigationBar: BottomAppBar(
              height: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
            )));
  }
}

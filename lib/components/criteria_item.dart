import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:property_evaluator/components/accordion_note.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:numberpicker/numberpicker.dart';

const double GAP_HEIGHT = 20;

class CriteriaItem extends StatelessWidget {
  const CriteriaItem({
    super.key,
    required this.item,
    required this.setNumber,
    required this.toggleExpand,
    required this.deleteNote,
    required this.addNote,
    required this.setNoteHeader,
    required this.setNoteBody,
    this.fromPropertyRoute = false,
    this.setName,
    this.deleteCriteria,
  });

  final Function(String noteId, bool isExpanded) toggleExpand;
  final Function(String noteId) deleteNote;
  final Function(NoteItem newNote) addNote;
  final Function(int noteIndex, String expandedValue) setNoteBody;
  final Function(int noteIndex, String headerValue) setNoteHeader;
  final Function(int numberValue) setNumber;
  final Function(String criteriaName)? setName;
  final Function()? deleteCriteria;
  final bool fromPropertyRoute;
  final CriteriaItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Slidable(
              enabled: !fromPropertyRoute,
              key: ValueKey(item.criteriaId),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  deleteCriteria?.call();
                }),
                children: [
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    icon: Icons.delete,
                    spacing: 4,
                    label: 'Delete',
                    borderRadius:
                        const BorderRadius.horizontal(right: Radius.circular(10)),
                  )
                ],
              ),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        style: fromPropertyRoute
                            ? TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold)
                            : null,
                        enabled: !fromPropertyRoute,
                        maxLength: 15,
                        initialValue: item.criteriaName,
                        onChanged: (value) => setName?.call(value),
                        decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            labelText: "Criteria",
                            hintText: "Enter Name"),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      fromPropertyRoute ? "Score: " : "Weight: ",
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(16),
                          border: Border(
                              bottom: BorderSide(
                                  width: 5,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary))),
                      margin: const EdgeInsets.only(right: 5),
                      child: NumberPicker(
                          itemWidth: 40,
                          itemHeight: 40,
                          haptics: true,
                          selectedTextStyle: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: "RobotoMono"),
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: "RobotoMono"),
                          value: fromPropertyRoute
                              ? item.weighting.toInt()
                              : (item.weighting * 100).toInt(),
                          itemCount: 1,
                          minValue: 0,
                          maxValue: fromPropertyRoute ? 10 : 100,
                          onChanged: setNumber),
                    ),
                    fromPropertyRoute
                        ? const SizedBox()
                        : Text(
                            "%",
                            style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          )
                  ]))),
          const SizedBox(height: GAP_HEIGHT),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: AccordionNote(
                toggleExpand: (noteId, isExpand) {
                  toggleExpand.call(noteId, isExpand);
                },
                deleteNote: (noteId) {
                  deleteNote.call(noteId);
                },
                setNoteHeader: (noteIndex, value) {
                  setNoteHeader.call(noteIndex, value);
                },
                setNoteBody: (noteIndex, value) {
                  setNoteBody.call(noteIndex, value);
                },
                notes: item.notes,
              )),
          const SizedBox(height: GAP_HEIGHT),
          ElevatedButton.icon(
              onPressed: () {
                addNote.call(NoteItem());
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text("Add a new note")),
          const SizedBox(height: GAP_HEIGHT),
          const Divider(
            indent: 40,
            endIndent: 40,
          )
        ]));
  }
}

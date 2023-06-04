import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_evaluator/components/accordion_note.dart';
import 'package:house_evaluator/model/criteria_item.dart';
import 'package:numberpicker/numberpicker.dart';

const double GAP_HEIGHT = 20;

class CriteriaItem extends StatelessWidget {
  CriteriaItem({
    super.key,
    this.criteriaReadOnly = false,
    required this.item,
    this.toggleExpand,
    this.deleteNote,
    this.addNote,
    this.setNoteHeader,
    this.setNoteBody,
  });

  final Function(String criteriaId, String noteId, bool isExpanded)?
      toggleExpand;
  final Function(String criteriaId, String noteId)? deleteNote;
  final Function(String criteriaId, NoteItem newNote)? addNote;
  final Function(String criteriaId, int noteIndex, String expandedValue)?
      setNoteBody;
  final Function(String criteriaId, int noteIndex, String headerValue)?
      setNoteHeader;
  final bool criteriaReadOnly;
  final CriteriaItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Slidable(
              enabled: !criteriaReadOnly,
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    icon: Icons.delete,
                    spacing: 4,
                    label: 'Delete',
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(10)),
                  )
                ],
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        maxLength: 15,
                        initialValue: item.criteriaName,
                        decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            labelText: "Criteria",
                            hintText: "Enter Name"),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Weight: ",
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
                      margin: EdgeInsets.only(right: 5),
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
                        value: (item.weighting * 100).toInt(),
                        itemCount: 1,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) => print(value),
                      ),
                    ),
                    Text(
                      "%",
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    )
                  ]))),
          const SizedBox(height: GAP_HEIGHT),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: AccordionNote(
                toggleExpand: (noteId, isExpand) {
                  toggleExpand?.call(item.criteriaId, noteId, isExpand);
                },
                deleteNote: (noteId) {
                  deleteNote?.call(item.criteriaId, noteId);
                },
                setNoteHeader: (noteIndex, value) {
                  setNoteHeader?.call(item.criteriaId, noteIndex, value);
                },
                setNoteBody: (noteIndex, value) {
                  setNoteBody?.call(item.criteriaId, noteIndex, value);
                },
                notes: item.notes,
              )),
          const SizedBox(height: GAP_HEIGHT),
          ElevatedButton.icon(
              onPressed: () {
                addNote?.call(item.criteriaId, NoteItem());
              },
              icon: Icon(Icons.add_rounded),
              label: Text("Add a new note")),
          const SizedBox(height: GAP_HEIGHT),
          const Divider(
            indent: 40,
            endIndent: 40,
          )
        ]));
  }
}

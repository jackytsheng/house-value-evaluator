import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_evaluator/components/accordion_note.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

class NoteItem {
  NoteItem({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String noteId = Uuid().v4();
  String? expandedValue;
  String? headerValue;
  bool isExpanded;
}

class CriteriaItem extends StatefulWidget {
  const CriteriaItem({super.key});

  @override
  State<CriteriaItem> createState() => _CriteriaItem();
}

class _CriteriaItem extends State<CriteriaItem> {
  final List<NoteItem> _notes = [];

  void toggleExpand(int index, bool isExpanded) {
    setState(() {
      String noteId = _notes[index].noteId;
      _notes.forEach((NoteItem item) => {
            if (noteId == item.noteId)
              {item.isExpanded = !isExpanded}
            else
              {item.isExpanded = false}
          });
      print(
          'element at index ${index}, id: ${noteId}, is setting from ${isExpanded}');
    });
  }

  void deleteNote(NoteItem currentItem) {
    setState(() {
      print("removing item: " + currentItem.noteId);
      _notes.removeWhere((NoteItem item) => currentItem.noteId == item.noteId);
      _notes.forEach((NoteItem element) {
        print(element.noteId);
        print(element.headerValue);
      });
    });
  }

  void setNoteHeader(String noteId, String headerValue) {
    setState(() {
      _notes.forEach((NoteItem item) {
        if (item.noteId == noteId) {
          print("setting header for: " + noteId);
          item.headerValue = headerValue;
        }
      });
    });
  }

  void setExpandedValue(String noteId, String expandedValue) {
    setState(() {
      setState(() {
        _notes.forEach((NoteItem item) {
          if (item.noteId == noteId) {
            print("setting content for: " + noteId);
            item.expandedValue = expandedValue;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Slidable(
              key: const ValueKey(0),
              // The start action pane is the one at the left or the top side.
              endActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),

                // All actions are defined in the children parameter.
                children: [
                  // A SlidableAction can have an icon and/or a label.
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
              child: Row(children: [
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    maxLength: 10,
                    validator: (value) {
                      if (value != null && value.length > 20) {
                        return "Criteria name must be less than 20 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
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
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: "RobotoMono"),
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: "RobotoMono"),
                    value: 0,
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
              ])),
          const SizedBox(height: 20),
          AccordionNote(
            toggleExpand: toggleExpand,
            notes: _notes,
            handleDelete: deleteNote,
            setNoteHeader: setNoteHeader,
            setExpandedValue: setExpandedValue,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _notes.forEach((NoteItem item) {
                    item.isExpanded = false;
                  });
                  // collapse all when added new to prevent bug that when one is open there other is then clicked
                  _notes.add(NoteItem());
                });
              },
              icon: Icon(Icons.add_rounded),
              label: Text("Add a new note")),
          const SizedBox(height: 20),
          const Divider(
            indent: 40,
            endIndent: 40,
          )
        ]));
  }
}

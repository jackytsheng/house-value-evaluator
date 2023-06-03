import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_evaluator/components/accordion_note.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

const double GAP_HEIGHT = 20;

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
  const CriteriaItem(
      {super.key, this.criteriaReadOnly = false, this.criteriaName = ""});

  final bool criteriaReadOnly;
  final String criteriaName;

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
              enabled: !widget.criteriaReadOnly,
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
                        initialValue: widget.criteriaName,
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
                  ]))),
          const SizedBox(height: GAP_HEIGHT),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: AccordionNote(
                toggleExpand: toggleExpand,
                notes: _notes,
                handleDelete: deleteNote,
                setNoteHeader: setNoteHeader,
                setExpandedValue: setExpandedValue,
              )),
          const SizedBox(height: GAP_HEIGHT),
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
          const SizedBox(height: GAP_HEIGHT),
          const Divider(
            indent: 40,
            endIndent: 40,
          )
        ]));
  }
}

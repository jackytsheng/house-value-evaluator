import 'package:flutter/material.dart';
import 'package:property_evaluator/model/criteria.dart';

class AccordionNote extends StatelessWidget {
  const AccordionNote({
    super.key,
    required this.notes,
    required this.toggleExpand,
    required this.deleteNote,
    required this.setNoteHeader,
    required this.setNoteBody,
  });

  final List<NoteItem> notes;
  final Function(String noteId, bool isExpanded) toggleExpand;
  final Function(String noteId) deleteNote;
  final Function(int noteIndex, String expandedValue) setNoteBody;
  final Function(int noteIndex, String headerValue) setNoteHeader;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        elevation: 4,
        expandIconColor: Theme.of(context).colorScheme.secondary,
        expansionCallback: (noteIndex, isExpanded) {
          toggleExpand(notes[noteIndex].noteId, isExpanded);
        },
        children: notes
            .asMap()
            .map<int, ExpansionPanel>((int index, NoteItem item) => MapEntry(
                index,
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        item.headerValue ?? "New Note",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    );
                  },
                  body: Column(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: ListTile(
                            title: Text(
                          item.expandedValue ?? "What's your thought ?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ))),
                    FilledButton.tonalIcon(
                        label: const Text("Edit"),
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              margin:
                                                  const EdgeInsets.only(bottom: 25),
                                              child: TextFormField(
                                                initialValue: item.headerValue,
                                                onChanged: (value) {
                                                  setNoteHeader(index, value);
                                                },
                                                maxLength: 20,
                                                decoration: const InputDecoration(
                                                  label: Text("Title"),
                                                  hintText: "New Note",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16)),
                                                  ),
                                                ),
                                              )),
                                          Container(
                                              margin:
                                                  const EdgeInsets.only(bottom: 20),
                                              height: 150,
                                              child: TextFormField(
                                                minLines: 10,
                                                maxLines: null,
                                                onChanged: (value) {
                                                  setNoteBody(index, value);
                                                },
                                                maxLength: 3000,
                                                decoration: const InputDecoration(
                                                    label: Text("Note"),
                                                    alignLabelWithHint: true,
                                                    hintText:
                                                        "What's your thought ?",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16)),
                                                    )),
                                              )),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FilledButton(
                                                  onPressed: () {
                                                    deleteNote(item.noteId);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                                FilledButton.tonal(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ]),
                                        ]))))),
                    const SizedBox(height: 20)
                  ]),
                  isExpanded: item.isExpanded,
                )))
            .values
            .toList());
  }
}

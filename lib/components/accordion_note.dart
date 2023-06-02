import 'package:flutter/material.dart';
import 'package:house_evaluator/components/criteria_item.dart';

class AccordionNote extends StatelessWidget {
  AccordionNote({
    super.key,
    required this.notes,
    required this.toggleExpand,
    required this.handleDelete,
    required this.setNoteHeader,
    required this.setExpandedValue,
  });

  final List<NoteItem> notes;
  final void Function(int, bool) toggleExpand;
  final void Function(NoteItem) handleDelete;
  final void Function(String, String) setNoteHeader;
  final void Function(String, String) setExpandedValue;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        elevation: 4,
        expandIconColor: Theme.of(context).colorScheme.secondary,
        expansionCallback: toggleExpand,
        children: notes.map<ExpansionPanel>((NoteItem item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  item.headerValue ?? "New Note",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
            },
            body: Column(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: ListTile(
                      title: Text(
                    item.expandedValue ?? "What's your thought ?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ))),
              FilledButton.tonalIcon(
                  label: Text("Edit"),
                  icon: Icon(Icons.edit_rounded),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 25),
                                        child: TextFormField(
                                          initialValue: item.headerValue,
                                          onChanged: (value) {
                                            setNoteHeader(item.noteId, value);
                                          },
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                            label: Text("Title"),
                                            hintText: "New Note",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                            ),
                                          ),
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        height: 150,
                                        child: TextFormField(
                                          minLines: 10,
                                          maxLines: null,
                                          onChanged: (value) {
                                            setExpandedValue(
                                                item.noteId, value);
                                          },
                                          maxLength: 3000,
                                          decoration: InputDecoration(
                                              label: Text("Note"),
                                              alignLabelWithHint: true,
                                              hintText: "What's your thought ?",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                              )),
                                        )),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FilledButton(
                                            onPressed: () {
                                              handleDelete(item);
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
          );
        }).toList());
  }
}

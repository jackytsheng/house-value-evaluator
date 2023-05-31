// stores ExpansionPanel state information
import 'package:flutter/material.dart';

class AccordionNote extends StatefulWidget {
  const AccordionNote({super.key});

  @override
  State<AccordionNote> createState() => _AccordionNote();
}

class _AccordionNote extends State<AccordionNote> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.all(0),
        elevation: 0,
        // dividerColor: Theme.of(context).colorScheme.oninversePrimary,
        expandIconColor: Theme.of(context).colorScheme.secondary,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Note",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
            },
            body: ListTile(
                title: Text("Common"),
                subtitle:
                    const Text('To delete this panel, tap the trash can icon'),
                onTap: () {}),
            isExpanded: _isExpanded,
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Note",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
            },
            body: ListTile(
                title: Text("Common"),
                subtitle:
                    const Text('To delete this panel, tap the trash can icon'),
                onTap: () {}),
            isExpanded: _isExpanded,
          )
        ]);
  }
}

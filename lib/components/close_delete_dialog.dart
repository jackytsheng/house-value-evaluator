import 'package:flutter/material.dart';

class CloseDeleteDialog extends StatelessWidget {
  const CloseDeleteDialog(
      {super.key, required this.onDelete, required this.children});

  final Function() onDelete;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ...children,
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.error),
                  ),
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.onError),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ])
            ]));
  }
}

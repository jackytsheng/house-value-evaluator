import 'package:flutter/material.dart';

class HelpIconButton extends StatelessWidget {
  const HelpIconButton({super.key, required this.childrenMessages});

  final List<Widget> childrenMessages;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.info_rounded, size: 30),
        tooltip: 'Show help message',
        enableFeedback: true,
        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Instruction",
                          style: Theme.of(context).textTheme.titleMedium),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: childrenMessages,
                          )),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

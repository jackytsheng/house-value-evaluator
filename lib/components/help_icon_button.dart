import 'package:flutter/material.dart';

class HelpIconButton extends StatelessWidget {
  const HelpIconButton({super.key, required this.helpMessage});

  final String helpMessage;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.info_rounded,
            color: Theme.of(context).colorScheme.onInverseSurface, size: 30),
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
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(helpMessage)),
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

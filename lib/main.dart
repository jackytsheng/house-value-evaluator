import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_evaluator/route/home_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(HomeEvaluatorApp());
}

class HomeEvaluatorApp extends StatefulWidget {
  HomeEvaluatorApp({super.key});

  @override
  State<HomeEvaluatorApp> createState() => _HomeEvaluatorApp();
}

class _HomeEvaluatorApp extends State<HomeEvaluatorApp> {
  Color selectedThemeColor = Colors.blue.shade200;

  void changeThemeColor(Color color) {
    setState(() {
      selectedThemeColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Evaluator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: selectedThemeColor),
        useMaterial3: true,
      ),
      home: HomeRoute(
        changeThemeColor: changeThemeColor,
        currentThemeColor: selectedThemeColor,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_evaluator/constants/route.dart';
import 'package:house_evaluator/model/criteria_item.dart';
import 'package:house_evaluator/route/criteria_route.dart';
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
  List<CriteriaItemEntity> criteriaItems = [
    CriteriaItemEntity([], "Score", 100)
  ];

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
      routes: {
        CRITERIA_ROUTE: (context) =>
            CriteriaRoute(criteriaItems: criteriaItems),
      },
      home: HomeRoute(
        changeThemeColor: changeThemeColor,
        currentThemeColor: selectedThemeColor,
      ),
    );
  }
}

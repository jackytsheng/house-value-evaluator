import 'package:flutter/material.dart';
import 'package:house_evaluator/route/additional_rost_route.dart';
import 'package:house_evaluator/components/house_card.dart';
import 'package:house_evaluator/route/compare_route.dart';
import 'package:house_evaluator/route/criteria_route.dart';
import 'package:house_evaluator/route/property_route.dart';
import 'package:house_evaluator/route/settings_route.dart';
import 'package:house_evaluator/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
      title: 'Home Value Evaluator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: selectedThemeColor),
        useMaterial3: true,
      ),
      home: MyHomePage(
        changeThemeColor: changeThemeColor,
        currentThemeColor: selectedThemeColor,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage(
      {super.key,
      required this.changeThemeColor,
      required this.currentThemeColor});

  final Function(Color color) changeThemeColor;
  final Color currentThemeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.palette_rounded,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  size: 30),
              tooltip: "Change color theme",
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem<Color>(
                    value: Colors.pink.shade200,
                    child: Row(children: <Widget>[
                      Text("Cherry"),
                      const Spacer(),
                      Icon(Icons.fiber_manual_record_rounded,
                          color: Colors.pink.shade100),
                    ]),
                  ),
                  PopupMenuItem<Color>(
                    value: Colors.deepPurple.shade400,
                    child: Row(children: <Widget>[
                      Text("Lavender"),
                      const Spacer(),
                      Icon(Icons.fiber_manual_record_rounded,
                          color: Colors.deepPurple.shade100),
                    ]),
                  ),
                  PopupMenuItem<Color>(
                    value: Colors.blue.shade400,
                    child: Row(children: <Widget>[
                      Text("Arctic"),
                      const Spacer(),
                      Icon(Icons.fiber_manual_record_rounded,
                          color: Colors.blue.shade100),
                    ]),
                  ),
                  PopupMenuItem<Color>(
                    value: Colors.green.shade400,
                    child: Row(children: <Widget>[
                      Text("Avocado"),
                      const Spacer(),
                      Icon(Icons.fiber_manual_record_rounded,
                          color: Colors.green.shade200),
                    ]),
                  ),
                ];
              },
              initialValue: currentThemeColor,
              // Callback that sets the selected popup menu item.
              onSelected: changeThemeColor,
            ),
          ],
          scrolledUnderElevation: 0,
          title: Text("Home Value Evaluator",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                HouseCard(
                  address: "2 Exeter Ct, Wheelers Hill",
                  overallScore: 5.9,
                  price: Price(PriceState.sold, 1524000),
                  propertyType: PropertyType.house,
                ),
                HouseCard(
                  address: "2/15 Packham Crescent, Glen Waverley",
                  overallScore: 6.05,
                  price: Price(PriceState.estimated, 15050000),
                  propertyType: PropertyType.townHouse,
                ),
                HouseCard(
                  address: "1704 33 Blackwood Street, North Melbourne",
                  overallScore: 4.05,
                  price: Price(PriceState.sold, 550000),
                  propertyType: PropertyType.apartment,
                ),
                HouseCard(
                  address: "2/15 Packham Crescent, Glen Waverley",
                  overallScore: 10,
                  price: Price(PriceState.estimated, 15050000),
                  propertyType: PropertyType.townHouse,
                ),
                HouseCard(
                  address: "2/15 Packham Crescent, Glen Waverley",
                  overallScore: 1,
                  price: Price(PriceState.estimated, 15050000),
                  propertyType: PropertyType.townHouse,
                )
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PropertyRoute()));
          },
          shape: const CircleBorder(),
          tooltip: 'Add new address',
          child: Icon(Icons.add_home_work_rounded,
              size: 30, color: Theme.of(context).colorScheme.onPrimary),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            height: 70,
            color: Theme.of(context).colorScheme.inversePrimary,
            clipBehavior: Clip.hardEdge,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: IconTheme(
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(children: <Widget>[
                IconButton(
                  iconSize: 40,
                  tooltip: 'Comparison',
                  icon: const Icon(Icons.bar_chart_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompareRoute()));
                  },
                ),
                IconButton(
                  iconSize: 40,
                  tooltip: 'Criteria',
                  icon: const Icon(Icons.format_list_numbered_rtl_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CriteriaRoute()),
                    );
                  },
                ),
                const Spacer(),
                IconButton(
                  iconSize: 40,
                  tooltip: 'Additional cost',
                  icon: const Icon(Icons.price_change_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdditionalCostRoute()));
                  },
                ),
                IconButton(
                    iconSize: 40,
                    tooltip: 'Settings',
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsRoute()));
                    }),
              ]),
            )));
  }
}

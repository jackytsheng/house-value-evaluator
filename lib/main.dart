import 'package:flutter/material.dart';
import 'package:house_evaluator/route/additional_rost_route.dart';
import 'package:house_evaluator/components/house_card.dart';
import 'package:house_evaluator/route/compare_route.dart';
import 'package:house_evaluator/route/criteria_route.dart';
import 'package:house_evaluator/route/new_property_route.dart';
import 'package:house_evaluator/route/settings_route.dart';
import 'package:house_evaluator/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Value Evaluator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffe4012b)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Value Evaluator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: turn the payload into mock json and mapper
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title,
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
                  overallScore: 6.05,
                  price: Price(PriceState.estimated, 15050000),
                  propertyType: PropertyType.townHouse,
                ),
                HouseCard(
                  address: "2/15 Packham Crescent, Glen Waverley",
                  overallScore: 6.05,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewPropertyRoute()));
          },
          shape: const CircleBorder(),
          tooltip: 'Add new address',
          child: Icon(Icons.add_home_work_rounded,
              size: 30, color: Theme.of(context).colorScheme.onPrimary),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            height: 80,
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

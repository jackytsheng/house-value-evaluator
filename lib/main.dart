import 'package:flutter/material.dart';
import 'package:house_evaluator/card.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade100),
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
    initializeCounter();
  }

  Future<void> initializeCounter() async {
    await getCounterData();
    setState(() {}); // Trigger a rebuild after fetching the counter data
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
                ElevatedCard(
                  address: "2 Exeter Ct, Wheelers Hill",
                  overallScore: 5.9,
                  price: Price(PriceState.sold, 1524000),
                  propertyType: PropertyType.house,
                ),
                ElevatedCard(
                  address: "2/15 Packham Crescent, Glen Waverley",
                  overallScore: 6.05,
                  price: Price(PriceState.estimated, 15050000),
                  propertyType: PropertyType.townHouse,
                ),
                ElevatedCard(
                  address: "1704 33 Blackwood Street, North Melbourne",
                  overallScore: 3.05,
                  price: Price(PriceState.sold, 660000),
                  propertyType: PropertyType.apartment,
                ),
                ElevatedCard(
                  address: "2/15 Packham Crescent, Glen Waverley",
                  overallScore: 6.05,
                  price: Price(PriceState.estimated, 15050000),
                  propertyType: PropertyType.townHouse,
                ),
                ElevatedCard(
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
          onPressed: () {},
          shape: const CircleBorder(),
          tooltip: 'Add new address',
          child: Icon(Icons.add_home_work,
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
                  icon: const Icon(Icons.bar_chart),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 40,
                  tooltip: 'Criteria',
                  icon: const Icon(Icons.format_list_numbered_rtl),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  iconSize: 40,
                  tooltip: 'Additional cost',
                  icon: const Icon(Icons.price_change),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 40,
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ]),
            )));
  }

  Future<void> getCounterData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("count");
  }
}

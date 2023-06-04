import 'package:flutter/material.dart';
import 'package:house_evaluator/components/help_icon_button.dart';
import 'package:house_evaluator/components/house_card.dart';
import 'package:house_evaluator/route/additional_cost_route.dart';
import 'package:house_evaluator/route/compare_route.dart';
import 'package:house_evaluator/route/criteria_route.dart';
import 'package:house_evaluator/model/house_card.dart';

import 'package:house_evaluator/route/property_route.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute(
      {super.key,
      required this.changeThemeColor,
      required this.currentThemeColor});

  final Function(Color color) changeThemeColor;
  final Color currentThemeColor;

  @override
  State<StatefulWidget> createState() => _HomeRoute();
}

class _HomeRoute extends State<HomeRoute> {
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: <Widget>[
                IconButton(
                    iconSize: 40,
                    tooltip: 'Select cards',
                    icon: Icon(Icons.dns_rounded,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        size: 30),
                    onPressed: () {
                      setState(() {
                        _editMode = !_editMode;
                      });
                    }),
                HelpIconButton(helpMessage: "Unit price consist of maxi"),
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
                  initialValue: widget.currentThemeColor,
                  // Callback that sets the selected popup menu item.
                  onSelected: widget.changeThemeColor,
                ),
              ],
              scrolledUnderElevation: 0,
              title: Text("House Evaluator",
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
                      isEditMode: _editMode,
                      address: "2 Exeter Ct, Wheelers Hill",
                      overallScore: 5.9,
                      price: Price(PriceState.sold, 1524000),
                      propertyType: PropertyType.house,
                    ),
                    HouseCard(
                      isEditMode: _editMode,
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
            floatingActionButton: _editMode
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PropertyRoute()));
                    },
                    shape: const CircleBorder(),
                    tooltip: 'Add new address',
                    child: Icon(Icons.add_home_work_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
                height: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
                clipBehavior: Clip.hardEdge,
                shape: const CircularNotchedRectangle(),
                notchMargin: 8,
                child: IconTheme(
                  data: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: _editMode
                      ? Row(children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CompareRoute()));
                              },
                              icon: const Icon(Icons.bar_chart_rounded),
                              label: Text("Compare")),
                          const Spacer(),
                          ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.delete_rounded),
                              label: Text("Remove")),
                        ])
                      : Row(children: <Widget>[
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
                            icon: const Icon(Icons.assignment_rounded),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CriteriaRoute()),
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
                                      builder: (context) =>
                                          const AdditionalCostRoute()));
                            },
                          )
                        ]),
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:property_evaluator/components/close_delete_dialog.dart';
import 'package:property_evaluator/components/help_icon_button.dart';
import 'package:property_evaluator/components/property_card.dart';
import 'package:property_evaluator/constants/route.dart';
import 'package:property_evaluator/model/property.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({
    super.key,
    required this.changeThemeColor,
    required this.currentThemeColor,
    required this.properties,
    required this.addProperty,
    required this.toggleEditMode,
    required this.isEditMode,
    required this.selectedPropertyIds,
    required this.selectProperty,
    required this.deselectProperty,
    required this.deleteAllSelected,
  });

  final Function(Color color) changeThemeColor;
  final Function(BuildContext context) addProperty;
  final Function() toggleEditMode;
  final Function(String propertyId) selectProperty;
  final Function(String propertyId) deselectProperty;
  final Function() deleteAllSelected;
  final Color currentThemeColor;
  final bool isEditMode;
  final List<String> selectedPropertyIds;
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: <Widget>[
                const HelpIconButton(helpMessage: """
1. Select cards to compare

2. Select cards to delete

3. Score color change base on number

4. Selected cards auto show in compare
"""),
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
                          const Text("Cherry"),
                          const Spacer(),
                          Icon(Icons.fiber_manual_record_rounded,
                              color: Colors.pink.shade100),
                        ]),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.deepPurple.shade400,
                        child: Row(children: <Widget>[
                          const Text("Lavender"),
                          const Spacer(),
                          Icon(Icons.fiber_manual_record_rounded,
                              color: Colors.deepPurple.shade100),
                        ]),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.blue.shade400,
                        child: Row(children: <Widget>[
                          const Text("Arctic"),
                          const Spacer(),
                          Icon(Icons.fiber_manual_record_rounded,
                              color: Colors.blue.shade100),
                        ]),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.green.shade400,
                        child: Row(children: <Widget>[
                          const Text("Avocado"),
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
                IconButton(
                    iconSize: 40,
                    tooltip: 'Select cards',
                    icon: Icon(Icons.more_vert_rounded,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        size: 30),
                    onPressed: toggleEditMode)
              ],
              scrolledUnderElevation: 0,
              title: Text("Property Evaluator",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                    children: properties
                        .map<PropertyCard>((property) => PropertyCard(
                            isEditMode: isEditMode,
                            isSelected: selectedPropertyIds
                                .contains(property.propertyId),
                            property: property,
                            onSelect: () => selectProperty(property.propertyId),
                            onDeselect: () =>
                                deselectProperty(property.propertyId)))
                        .toList()),
              ),
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
            floatingActionButton: isEditMode
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      addProperty(context);
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
                  child: isEditMode
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(context, COMPARE_ROUTE);
                                    toggleEditMode();
                                  },
                                  icon: const Icon(Icons.bar_chart_rounded),
                                  label: const Text("Compare")),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Dialog(
                                                child: CloseDeleteDialog(
                                                    onDelete: deleteAllSelected,
                                                    children: [
                                                  Text(
                                                    "Doing so will remove all notes related as well. Are you sure you want to delete selected properties?",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error),
                                                  ),
                                                  const SizedBox(height: 10)
                                                ])));
                                  },
                                  icon: const Icon(Icons.delete_rounded),
                                  label: const Text("Remove")),
                            ])
                      : Row(children: <Widget>[
                          IconButton(
                            iconSize: 40,
                            tooltip: 'Comparison',
                            icon: const Icon(Icons.bar_chart_rounded),
                            onPressed: () {
                              Navigator.pushNamed(context, COMPARE_ROUTE);
                            },
                          ),
                          IconButton(
                            iconSize: 40,
                            tooltip: 'Criteria',
                            icon: const Icon(Icons.assignment_rounded),
                            onPressed: () {
                              Navigator.pushNamed(context, CRITERIA_ROUTE);
                            },
                          ),
                          const Spacer(),
                          IconButton(
                            iconSize: 40,
                            tooltip: 'Additional cost',
                            icon: const Icon(Icons.price_change_rounded),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, ADDITIONAL_COST_ROUTE);
                            },
                          )
                        ]),
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:property_evaluator/components/close_delete_dialog.dart';
import 'package:property_evaluator/components/help_icon_button.dart';
import 'package:property_evaluator/components/property_card.dart';
import 'package:property_evaluator/constants/route.dart';
import 'package:property_evaluator/model/property.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({
    super.key,
    required this.toggleThemeMode,
    required this.currentThemeMode,
    required this.properties,
    required this.addProperty,
    required this.toggleEditMode,
    required this.isEditMode,
    required this.selectedPropertyIds,
    required this.togglePropertySelect,
    required this.export,
    required this.deleteAllSelected,
  });

  final Function() toggleThemeMode;
  final Function(BuildContext context) addProperty;
  final Function() toggleEditMode;
  final Function() export;
  final Function(String propertyId) togglePropertySelect;
  final Function() deleteAllSelected;
  final ThemeMode currentThemeMode;
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
              actions: <Widget>[
                const HelpIconButton(helpMessage: """
1. Select cards to compare

2. Select cards to delete

3. Score color change base on number

4. Selected cards auto show in compare
"""),
                IconButton(
                    iconSize: 40,
                    tooltip: currentThemeMode == ThemeMode.light
                        ? 'Light mode'
                        : "Dark mode",
                    icon: Icon(
                        currentThemeMode == ThemeMode.light
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        size: 30),
                    onPressed: toggleThemeMode),
                IconButton(
                    iconSize: 40,
                    tooltip: 'Select cards',
                    icon: const Icon(Icons.more_vert_rounded, size: 30),
                    onPressed: toggleEditMode)
              ],
              scrolledUnderElevation: 10,
              elevation: 10,
              title: const Text("Property Evaluator",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                              onToggle: () =>
                                  togglePropertySelect(property.propertyId),
                            ))
                        .toList()),
              ),
            ),
            floatingActionButton: isEditMode
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      addProperty(context);
                    },
                    shape: const CircleBorder(),
                    tooltip: 'Add new address',
                    child: const Icon(
                      Icons.add_home_work_rounded,
                      size: 30,
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              height: 80,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
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
                                    builder: (BuildContext context) => Dialog(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .errorContainer,
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
                          Navigator.pushNamed(context, ADDITIONAL_COST_ROUTE);
                        },
                      ),
                      IconButton(
                        iconSize: 40,
                        tooltip: 'Export stored files',
                        icon: const Icon(Icons.download_for_offline_rounded),
                        onPressed: export,
                      )
                    ]),
            )));
  }
}

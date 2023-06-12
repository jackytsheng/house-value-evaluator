import 'package:flutter/material.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompareRoute extends StatelessWidget {
  const CompareRoute(
      {super.key,
      required this.propertiesMap,
      required this.selectedPropertyIds,
      required this.criteriaItemsMap});

  final Map<String, PropertyEntity> propertiesMap;
  final Map<String, CriteriaItemEntity> criteriaItemsMap;
  final List<String> selectedPropertyIds;

  @override
  Widget build(BuildContext context) {
    final List<String> chartData = criteriaItemsMap.keys.toList();
    return Scaffold(
        appBar: ThemedAppBar(title: "Compare property", childrenMessages: [
          Text("1. Click property name to hide or show",
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text("2. Property names can be scrolled horizontally",
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text("3. Click each bar to view score",
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text("4. Hold any bar to view the comparison",
              style: Theme.of(context).textTheme.bodySmall),
        ]),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 40,
                  right: 5,
                ),
                child: selectedPropertyIds.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Selected Properties to Compare"),
                      )
                    : SfCartesianChart(
                        primaryYAxis: NumericAxis(minimum: 0, maximum: 10),
                        primaryXAxis: CategoryAxis(
                            majorTickLines: const MajorTickLines(width: 0),
                            majorGridLines: const MajorGridLines(width: 0)),
                        isTransposed: true,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                          width: '300%',
                          isVisible: true,
                        ),
                        selectionType: SelectionType.series,
                        trackballBehavior: TrackballBehavior(
                            lineWidth: 0,
                            tooltipDisplayMode:
                                TrackballDisplayMode.groupAllPoints,
                            enable: true,
                            markerSettings: const TrackballMarkerSettings(
                                borderWidth: 5,
                                markerVisibility:
                                    TrackballVisibilityMode.visible)),
                        series: selectedPropertyIds.map((propertyId) {
                          var property = propertiesMap[propertyId]!;
                          return ColumnSeries<String, String>(
                            dataSource: chartData,
                            name: property.address,
                            xValueMapper: (String criteriaId, __) =>
                                criteriaItemsMap[criteriaId]?.criteriaName,
                            yValueMapper: (String criteriaId, __) => property
                                .propertyAssessmentMap[criteriaId]?.score,
                          );
                        }).toList()))));
  }
}

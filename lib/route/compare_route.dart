import 'package:flutter/material.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// class House {
//   final String name;
//   final double traffic;
//   final double condition;

//   House({required this.name, required this.traffic, required this.condition});
// }
// List<House> houses = [
//   House(name: 'House 1', traffic: 5, condition: 10),
//   House(name: 'House 2', traffic: 10, condition: 9),
// ];
class CompareRoute extends StatelessWidget {
  const CompareRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('School', 1.2, 3, 7.2, 2, 2, 2, 2, 2, 2, 2, 2),
      ChartData('Traffic', 1, 2, 5, 2, 2, 2, 2, 2, 2, 2, 2),
      ChartData('Condition', 1, 2, 5, 2, 2, 2, 2, 2, 2, 2, 2),
      ChartData('Score', 1, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2),
    ];
    return Scaffold(
        appBar: const ThemedAppBar(
          title: "Compare property",
          helpMessage: """
        1. Scroll legend list horizontally
        
        2. Click legend to toggle visibility

        3. Click a single bar to view detail

        4. Hold down to view details
        """,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: SfCartesianChart(
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 30, left: 15, right: 35),
                    primaryYAxis: NumericAxis(minimum: 0, maximum: 10),
                    primaryXAxis: CategoryAxis(
                        labelRotation: 90,
                        majorTickLines: const MajorTickLines(width: 0),
                        majorGridLines: const MajorGridLines(width: 0)),
                    isTransposed: true,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: Legend(
                      isVisible: true,
                    ),
                    selectionType: SelectionType.series,
                    trackballBehavior: TrackballBehavior(
                        lineWidth: 0,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        enable: true,
                        markerSettings: const TrackballMarkerSettings(
                            borderWidth: 5,
                            markerVisibility: TrackballVisibilityMode.visible)),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          name: "1704 33 blackwood",
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                      ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          name: "86 Great Ryrie",
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y1),
                      ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          name: "206 Blackmont",
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y2),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y2),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y1),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y2),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y2),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y1),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y1),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y2),
                      // ColumnSeries<ChartData, String>(
                      //     dataSource: chartData,
                      //     xValueMapper: (ChartData data, _) => data.x,
                      //     yValueMapper: (ChartData data, _) => data.y2)
                    ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2, this.y3, this.y4, this.y5,
      this.y6, this.y7, this.y8, this.y9, this.y10);
  final String x;
  final double? y;
  final double? y1;
  final double? y2;
  final double? y3;
  final double? y4;
  final double? y5;
  final double? y6;
  final double? y7;
  final double? y8;
  final double? y9;
  final double? y10;
}

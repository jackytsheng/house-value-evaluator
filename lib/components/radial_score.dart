import 'package:flutter/material.dart';
import 'package:house_evaluator/components/color_scale_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}

class RadialScore extends StatelessWidget {
  RadialScore({super.key});
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Score', 2),
      ChartData('School', 8),
      ChartData('Traffic', 8),
      ChartData('Gym', 3),
      ChartData('Traffic', 8),
      ChartData('Traffic', 8),
      ChartData('Gym', 3),
      ChartData('Gym', 3),
      ChartData('Gym', 3),
      ChartData('Gym', 3),
      ChartData('Gym', 3),
    ];
    return SfCircularChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        annotations: [
          CircularChartAnnotation(
              widget: ColorScaleWidget(
                  value: 8,
                  minValue: 0,
                  minColor: Theme.of(context).colorScheme.onPrimary,
                  lightTextColor: Theme.of(context).colorScheme.onSecondary,
                  maxValue: 10,
                  darkTextColor: Theme.of(context).colorScheme.inverseSurface,
                  maxColor: Theme.of(context).colorScheme.inversePrimary,
                  width: 68,
                  height: 68,
                  borderRadius: 100,
                  child: Center(
                      child: Text(
                    8.toStringAsFixed(2),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))))
        ],
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
        ),
        series: <CircularSeries>[
          // Renders radial bar chart
          RadialBarSeries<ChartData, String>(
              maximumValue: 10,
              useSeriesColor: true,
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              radius: '90%',
              innerRadius: '30%',
              trackOpacity: 0.4,
              animationDuration: 1000,
              cornerStyle: CornerStyle.bothCurve),
        ]);
  }
}

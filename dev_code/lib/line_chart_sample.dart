import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatelessWidget {
  final List<FlSpot> dataPoints;

  const LineChartSample({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 30,
        minY: -1000,
        maxY: 5000,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1000),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 5),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: true,
            barWidth: 3,
            color: Colors.blue,
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

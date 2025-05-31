import 'package:flutter/material.dart';

// Data model for individual bar chart data points
class BarChartDataPoint {
  final int x; // Represents the day or index
  final double y; // Represents the value (e.g., sales amount)
  final Color color;

  BarChartDataPoint({
    required this.x,
    required this.y,
    this.color = Colors.lightBlue,
  });
}

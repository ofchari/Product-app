import 'dart:math'; // For random data generation
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../model/data_model/chart.dart';

class CustomBarChart extends StatefulWidget {
  final String categoryTitle;

  const CustomBarChart({super.key, required this.categoryTitle});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  late List<BarChartDataPoint> _dummyData;
  final Random _random = Random();
  final int _dataPoints = 7; // Show data for the last 7 days

  @override
  void initState() {
    super.initState();
    _dummyData = _generateDummyData();
  }

  // Generate dummy data for the last 7 days
  List<BarChartDataPoint> _generateDummyData() {
    final List<BarChartDataPoint> data = [];
    final now = DateTime.now();
    for (int i = _dataPoints - 1; i >= 0; i--) {
      // Simulate data based on category (just for variety)
      double value;
      switch (widget.categoryTitle) {
        case 'Sales':
          value = _random.nextDouble() * 1000 + 500; // Higher values for sales
          break;
        case 'Production':
          value = _random.nextDouble() * 500 + 200;
          break;
        case 'Purchase':
          value = _random.nextDouble() * 800 + 300;
          break;
        default:
          value = _random.nextDouble() * 300 + 100;
      }
      data.add(
        BarChartDataPoint(
          x: _dataPoints - 1 - i, // Index 0 to 6
          y: value,
          color:
              Colors
                  .primaries[_random.nextInt(Colors.primaries.length)]
                  .shade300,
        ),
      );
    }
    return data;
  }

  // Get the date corresponding to the bar index
  DateTime _getDateForIndex(int index) {
    final now = DateTime.now();
    return now.subtract(Duration(days: _dataPoints - 1 - index));
  }

  @override
  Widget build(BuildContext context) {
    if (_dummyData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Find the maximum Y value to set the chart's top limit
    final maxY =
        _dummyData.map((data) => data.y).reduce(max) * 1.2; // Add 20% padding

    return AspectRatio(
      aspectRatio: 1.7, // Adjust aspect ratio as needed
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            top: 16.h,
            bottom: 10.h,
            left: 10.w,
            right: 18.w,
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  // tooltipBgColor: Colors.blueGrey,
                  tooltipPadding: EdgeInsets.all(8.w),
                  tooltipMargin: 8.h,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final dataPoint = _dummyData[group.x];
                    final date = _getDateForIndex(group.x);
                    return BarTooltipItem(
                      '${DateFormat('MMM d').format(date)}\n',
                      GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: dataPoint.y.toStringAsFixed(2),
                          style: GoogleFonts.lato(
                            color: Colors.yellow,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _bottomTitles,
                    reservedSize: 38.h,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40.w,
                    getTitlesWidget: _leftTitles,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups:
                  _dummyData.map((dataPoint) {
                    return BarChartGroupData(
                      x: dataPoint.x,
                      barRods: [
                        BarChartRodData(
                          toY: dataPoint.y,
                          color: dataPoint.color,
                          width: 15.w,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                      showingTooltipIndicators: [],
                    );
                  }).toList(),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for bottom axis titles (Dates)
  Widget _bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= _dummyData.length) return Container();

    final date = _getDateForIndex(index);
    final text = DateFormat('E').format(date); // Show Day initial (e.g., Mon)

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10.h, // Space between bar and title
      child: Text(
        text,
        style: GoogleFonts.lato(fontSize: 11.sp, color: Colors.grey[700]),
      ),
    );
  }

  // Widget for left axis titles (Values)
  Widget _leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) return Container(); // Avoid overlapping with top
    // Format large numbers concisely (e.g., 1.5k)
    String text;
    if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      text = value.toStringAsFixed(0);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.w,
      child: Text(
        text,
        style: GoogleFonts.lato(fontSize: 11.sp, color: Colors.grey[700]),
        textAlign: TextAlign.center,
      ),
    );
  }
}

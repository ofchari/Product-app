import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../model/data_model/report.dart';
import '../screens/full_screen.dart'; // Import the new screen

class ReportDataTable extends StatefulWidget {
  final String categoryTitle;

  const ReportDataTable({super.key, required this.categoryTitle});

  @override
  State<ReportDataTable> createState() => _ReportDataTableState();
}

class _ReportDataTableState extends State<ReportDataTable> {
  late List<ReportDataRow> _dummyData;
  final Random _random = Random();
  final int _summaryRowCount = 6; // Number of rows to show in summary
  final DateFormat _summaryDateFormat = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    // Generate data once and store it to pass to the full report screen
    _dummyData = _generateDummyData(25);
  }

  // Generate dummy data
  List<ReportDataRow> _generateDummyData(int count) {
    final List<ReportDataRow> data = [];
    final List<String> statuses = [
      "Completed",
      "Pending",
      "Failed",
      "In Progress",
    ];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      data.add(
        ReportDataRow(
          id: "ID-${1000 + i}",
          date: now.subtract(
            Duration(days: _random.nextInt(30), hours: _random.nextInt(24)),
          ),
          description:
              "${widget.categoryTitle} transaction ${_random.nextInt(100)}",
          amount: _random.nextDouble() * 500 + 50,
          status: statuses[_random.nextInt(statuses.length)],
        ),
      );
    }
    data.sort((a, b) => b.date.compareTo(a.date));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.categoryTitle} Report Summary',
                  style: GoogleFonts.lato(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the full report screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => FullReportScreen(
                                categoryTitle: widget.categoryTitle,
                                reportData:
                                    _dummyData, // Pass the generated data
                              ),
                        ),
                      );
                    },
                    child: Text(
                      "View Full Report",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildSummaryView(), // Always show the summary view here
          ],
        ),
      ),
    );
  }

  // Builds the summary view (first few rows, limited columns)
  Widget _buildSummaryView() {
    final summaryData = _dummyData.take(_summaryRowCount).toList();
    if (summaryData.isEmpty) {
      return const Text('No recent data available.');
    }

    return Column(
      children:
          summaryData.map((row) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              leading: CircleAvatar(
                radius: 15.r,
                child: Text(
                  row.id.substring(3),
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
              title: Text(
                row.description,
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                _summaryDateFormat.format(row.date),
                style: GoogleFonts.lato(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            );
          }).toList(),
    );
  }
}

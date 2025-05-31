import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/bar_charts.dart';
import '../widgets/reports_table.dart';

class DetailScreen extends StatelessWidget {
  final String categoryTitle;

  const DetailScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Ensure back button is white
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar Chart Section
            Text(
              'Activity Overview (Last 7 Days)',
              style: GoogleFonts.lato(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            SizedBox(height: 10.h),
            CustomBarChart(categoryTitle: categoryTitle),
            SizedBox(height: 24.h),

            // Data Table Section
            // The ReportDataTable widget includes its own header
            ReportDataTable(categoryTitle: categoryTitle),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../model/data_model/report.dart';

class FullReportScreen extends StatefulWidget {
  final String categoryTitle;
  final List<ReportDataRow> reportData; // Receive the full data list

  const FullReportScreen({
    super.key,
    required this.categoryTitle,
    required this.reportData,
  });

  @override
  State<FullReportScreen> createState() => _FullReportScreenState();
}

class _FullReportScreenState extends State<FullReportScreen> {
  late List<ReportDataRow> _sortedData;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    // Initialize with the passed data, already sorted by date descending
    _sortedData = List.from(widget.reportData);
  }

  void _sort<T>(
    Comparable<T> Function(ReportDataRow d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _sortedData.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create the DataTableSource here
    final DataTableSource dataSource = _ReportDataSource(context, _sortedData);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryTitle} - Full Report',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Use a SingleChildScrollView for the main page content to allow vertical scrolling if needed
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.w), // Add padding around the table container
        child: PaginatedDataTable(
          // Enable horizontal scrolling by default if columns are wide
          // The PaginatedDataTable handles its own scrolling internally when needed
          // based on the column widths and available space.
          header: Text(
            'All Records',
            style: GoogleFonts.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: const [5, 10, 20, 25, 50],
          onRowsPerPageChanged: (value) {
            setState(() {
              _rowsPerPage = value ?? PaginatedDataTable.defaultRowsPerPage;
            });
          },
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: _getColumns(),
          source: dataSource, // Use the created data source
          columnSpacing: 25.w, // Adjust spacing as needed
          horizontalMargin: 10.w, // Margin for the table itself
          showCheckboxColumn: false,
        ),
      ),
    );
  }

  List<DataColumn> _getColumns() {
    return [
      DataColumn(
        label: Text('ID', style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
        onSort:
            (columnIndex, ascending) =>
                _sort<String>((d) => d.id, columnIndex, ascending),
      ),
      DataColumn(
        label: Text(
          'Date',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
        onSort:
            (columnIndex, ascending) =>
                _sort<DateTime>((d) => d.date, columnIndex, ascending),
        numeric: false,
      ),
      DataColumn(
        label: Text(
          'Description',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
        onSort:
            (columnIndex, ascending) =>
                _sort<String>((d) => d.description, columnIndex, ascending),
      ),
      DataColumn(
        label: Text(
          'Amount',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
        onSort:
            (columnIndex, ascending) =>
                _sort<num>((d) => d.amount, columnIndex, ascending),
        numeric: true,
      ),
      DataColumn(
        label: Text(
          'Status',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
        onSort:
            (columnIndex, ascending) =>
                _sort<String>((d) => d.status, columnIndex, ascending),
      ),
    ];
  }
}

// Data source for PaginatedDataTable (No changes needed here)
class _ReportDataSource extends DataTableSource {
  final BuildContext context;
  final List<ReportDataRow> _data;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  _ReportDataSource(this.context, this._data);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) {
      return null;
    }
    final row = _data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(row.id, style: GoogleFonts.lato(fontSize: 13.sp))),
        DataCell(
          Text(
            _dateFormat.format(row.date),
            style: GoogleFonts.lato(fontSize: 13.sp),
          ),
        ),
        DataCell(
          Text(row.description, style: GoogleFonts.lato(fontSize: 13.sp)),
        ),
        DataCell(
          Text(
            row.amount.toStringAsFixed(2),
            style: GoogleFonts.lato(fontSize: 13.sp),
          ),
        ),
        DataCell(
          Text(
            row.status,
            style: GoogleFonts.lato(
              fontSize: 13.sp,
              color: _getStatusColor(row.status),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green.shade700;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Failed':
        return Colors.red.shade700;
      case 'In Progress':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0; // No selection implemented
}

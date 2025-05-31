// Data model for a single row in the report data table
class ReportDataRow {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final String status;

  ReportDataRow({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.status,
  });
}

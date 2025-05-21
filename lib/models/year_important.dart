// ignore_for_file: public_member_api_docs, sort_constructors_first
class YearImportant {
  final double start;
  final double end;
  final int column;

  const YearImportant(
      {required this.start, required this.column, required this.end});

  @override
  String toString() =>
      'YearImportant(start: $start, end: $end, column: $column)';
}

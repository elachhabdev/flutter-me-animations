// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class EventImportant {
  final double start;
  final double end;
  final String image;
  final Color color;
  final int column;

  const EventImportant(
      {required this.color,
      required this.column,
      required this.end,
      required this.image,
      required this.start});

  @override
  String toString() {
    return 'EventImportant(start: $start, end: $end, image: $image, color: $color, column: $column)';
  }
}

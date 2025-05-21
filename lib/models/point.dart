class Point {
  String date;
  double price;
  Point({required this.date, required this.price});
  @override
  String toString() {
    return '$date $price';
  }
}

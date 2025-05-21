// ignore_for_file: public_member_api_docs, sort_constructors_first
class Word {
  final int index;
  final String word;
  final List<int> correctIndex;

  const Word(
      {required this.index, required this.correctIndex, required this.word});

  @override
  String toString() =>
      'Word(index: $index, word: $word, correctIndex: $correctIndex)';
}

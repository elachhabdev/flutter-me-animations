import 'package:equatable/equatable.dart';

class Nom extends Equatable {
  final int index;
  final String alphabet;
  final String nom;
  final String prenom;
  final String image;
  final bool isalphabet;

  const Nom(
      {required this.index,
      required this.alphabet,
      required this.nom,
      required this.prenom,
      required this.image,
      required this.isalphabet});

  @override
  List<Object?> get props => [index];
}

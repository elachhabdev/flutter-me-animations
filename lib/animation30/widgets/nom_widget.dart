import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/nom.dart';

class NomWidget extends StatelessWidget {
  final Nom nom;
  final double containerHeight;
  final double fem;

  const NomWidget(
      {super.key,
      required this.nom,
      required this.containerHeight,
      required this.fem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: containerHeight,
      child: Row(children: [
        SizedBox(
          width: 10 * fem,
        ),
        if (!nom.isalphabet)
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade800,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(nom.image)),
          ),
        SizedBox(width: 10 * fem),
        Text('${nom.nom} ${nom.prenom}',
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        const Spacer(),
        const Icon(
          Icons.phone,
          color: Colors.green,
          size: 24,
        ),
        SizedBox(
          width: 10 * fem,
        ),
        const Icon(
          Icons.message,
          color: Colors.blue,
          size: 24,
        ),
        SizedBox(
          width: 15 * fem,
        ),
      ]),
    );
  }
}

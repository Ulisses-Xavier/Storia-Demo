import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChaptersNotFound extends StatelessWidget {
  const ChaptersNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Icon
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Icon(
              PhosphorIcons.fileX(PhosphorIconsStyle.fill),
              color: Colors.white,
              size: 20,
            ),
          ),

          //Main Text
          Text(
            'Nenhum capítulo encontrado',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            'Tente voltar outra hora ;)',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

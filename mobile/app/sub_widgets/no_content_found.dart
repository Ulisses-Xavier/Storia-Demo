import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoContentFound extends StatelessWidget {
  const NoContentFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          PhosphorIcons.fileX(PhosphorIconsStyle.fill),
          color: Colors.white,
          size: 30,
        ),
        SizedBox(height: 10),
        Text(
          'Nenhuma obra encontrada',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Tente outro termo de pesquisa ;)',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

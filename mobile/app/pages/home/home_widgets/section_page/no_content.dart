import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoContent extends StatelessWidget {
  const NoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Icon(PhosphorIcons.fileX(), color: Colors.white, size: 20),
          ),

          //Main Text
          Text(
            'Nenhuma obra encontrada',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            'Tente recarregar a página',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),

          Text(
            'ou voltar outra hora ;)',
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

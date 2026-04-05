import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Icon
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Icon(PhosphorIcons.fileX(), color: Colors.white, size: 20),
          ),

          //Main Text
          Text(
            'Erro ao carregar dados',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            'Tente novamente ou, se necessário,',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),

          Text(
            'atualizar a página',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),

          //Botão
        ],
      ),
    );
  }
}

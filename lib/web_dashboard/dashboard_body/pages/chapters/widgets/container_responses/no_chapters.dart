import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoChapters extends StatelessWidget {
  const NoChapters({super.key});

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
            child: Icon(LucideIcons.fileX100, color: Colors.white, size: 20),
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
            'Tente criar um novo',
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

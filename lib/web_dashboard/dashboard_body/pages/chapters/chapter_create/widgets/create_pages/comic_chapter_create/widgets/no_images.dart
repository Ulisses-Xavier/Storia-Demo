import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoImages extends StatelessWidget {
  final double? padding;
  final Color? color;
  const NoImages({super.key, this.color, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding != null ? padding! : 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Icon
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Icon(
              LucideIcons.imageOff,
              color: color ?? Colors.white,
              size: 20,
            ),
          ),

          //Main Text
          Text(
            'Nenhuma imagem adicionada',
            style: TextStyle(
              color: color ?? Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            'Tente fazer um upload',
            style: TextStyle(
              color: color ?? Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

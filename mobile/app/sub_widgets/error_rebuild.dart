import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/utilities/utilities.dart';

class ErrorRebuild extends StatelessWidget {
  final VoidCallback function;
  const ErrorRebuild({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.warningOctagon(PhosphorIconsStyle.fill),
                color: Colors.white,
                size: 30,
              ),
              SizedBox(height: 10),
              Text(
                'Houve um pequeno erro',
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
                'Gostaria de tentar novamente?',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 9,
                ),
              ),
              SizedBox(height: 16),
              MyButton(
                isSelected: false,
                height: 40,
                width: 145,
                color: ColorTheme.blue,
                text: 'Tentar novamente',
                textColor: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 12,
                alignment: MainAxisAlignment.center,
                spaceBetween: 0,
                borderRadius: 10,
                splashColor: Colors.transparent,
                onTap: () {
                  function();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

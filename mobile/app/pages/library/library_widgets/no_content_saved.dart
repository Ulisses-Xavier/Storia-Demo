import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/utilities/utilities.dart';

class NoContentSaved extends StatelessWidget {
  const NoContentSaved({super.key});

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
          'Nenhuma obra salva',
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
          'O que acha de dar uma olhada\nnas nossas coleções pra começar?',
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
          width: 130,
          color: ColorTheme.blue,
          text: 'Destaques',
          textColor: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 15,
          alignment: MainAxisAlignment.center,
          spaceBetween: 0,
          borderRadius: 10,
          splashColor: Colors.transparent,
          onTap: () {
            context.go('/home');
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/sub_pages/popups/login_bottom_sheet/login_bottom_sheet.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/utilities/utilities.dart';

class NoAuthenticated extends StatelessWidget {
  final bool isPopUp;
  final Color color;
  const NoAuthenticated({
    super.key,
    required this.isPopUp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 300,
      decoration: BoxDecoration(
        color: ColorTheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.lock(PhosphorIconsStyle.fill),
            color: Colors.white,
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            'Login necessário',
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
            'Quer ativar a biblioteca e salvar\nsuas obras favoritas?',
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
            text: 'Login',
            textColor: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 15,
            alignment: MainAxisAlignment.center,
            spaceBetween: 0,
            borderRadius: 10,
            splashColor: Colors.transparent,
            onTap: () {
              if (isPopUp) {
                Navigator.of(context).pop(true);
                return;
              }

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                backgroundColor: Colors.transparent,
                builder: (rootContext) {
                  return LoginBottomSheet(
                    color: color,
                    rootContext: rootContext,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

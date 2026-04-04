import 'package:flutter/material.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class CreateDrawConfirmPopup extends StatelessWidget {
  const CreateDrawConfirmPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: DashboardTheme.primary,
                border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deseja salvar como rascunho?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        MyButton(
                          alignment: MainAxisAlignment.center,
                          isSelected: false,
                          height: 40,
                          loadingColor: Colors.white,
                          width: 120,
                          color: DashboardTheme.blue,
                          splashColor: const Color.fromARGB(57, 255, 255, 255),
                          onHover: DashboardTheme.blue,
                          text: 'Salvar',
                          fontSize: 15,
                          borderRadius: 10,
                          textColor: Colors.white,
                          onTap: () => Navigator.of(context).pop(true),
                        ),
                        SizedBox(width: 6),
                        MyButton(
                          alignment: MainAxisAlignment.center,
                          isSelected: false,
                          height: 40,
                          loadingColor: Colors.white,
                          width: 160,
                          color: const Color.fromARGB(125, 42, 42, 42),
                          splashColor: const Color.fromARGB(57, 255, 255, 255),
                          onHover: const Color.fromARGB(170, 42, 42, 42),
                          text: 'Sair sem salvar',
                          fontSize: 15,
                          borderRadius: 10,
                          textColor: Colors.white,
                          onTap: () => Navigator.of(context).pop(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

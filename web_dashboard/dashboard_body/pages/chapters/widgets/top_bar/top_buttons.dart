import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class TopButtons extends StatefulWidget {
  final bool isSelected;
  final String? route;
  final String text;
  const TopButtons({
    super.key,
    required this.isSelected,
    required this.text,
    this.route,
  });

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: MyButton(
        isSelected: widget.isSelected,
        text: widget.text,
        color: Colors.transparent,
        height: 35,
        selectedColor: DashboardTheme.blue,
        textColor: Colors.white,
        fontSize: 13,
        fontFamily: 'Poppins',
        borderRadius: 10,
        onHover: const Color.fromARGB(101, 62, 62, 62),
        alignment: MainAxisAlignment.center,
        splashColor: const Color.fromARGB(31, 255, 255, 255),
        onTap: () {
          if (widget.route != null) {
            context.go(widget.route!);
            return;
          }
          if (widget.text == 'Publicados') {
            context.go('/dashboard/capitulos/publicados');
          } else if (widget.text == 'Agendados') {
            context.go('/dashboard/capitulos/agendados');
          } else {
            context.go('/dashboard/capitulos/rascunhos');
          }
        },
      ),
    );
  }
}

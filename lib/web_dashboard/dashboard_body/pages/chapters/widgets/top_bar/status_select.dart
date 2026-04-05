import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/top_bar/top_buttons.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class StatusSelect extends ConsumerStatefulWidget {
  const StatusSelect({super.key});

  @override
  ConsumerState<StatusSelect> createState() => _StatusSelectState();
}

class _StatusSelectState extends ConsumerState<StatusSelect> {
  @override
  Widget build(BuildContext context) {
    final path = GoRouter.of(context).state.uri.toString();
    return Container(
      height: 45,
      width: 400,
      decoration: BoxDecoration(
        color: DashboardTheme.secondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(30, 5, 5, 5),
            blurRadius: 5,
            spreadRadius: 5,
            offset: Offset.fromDirection(1, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            TopButtons(
              isSelected: path.contains('publicados'),
              text: 'Publicados',
            ),
            SizedBox(width: 2),
            TopButtons(
              isSelected: path.contains('agendados'),
              text: 'Agendados',
            ),
            SizedBox(width: 2),
            TopButtons(
              isSelected: path.contains('rascunhos'),
              text: 'Rascunhos',
            ),
          ],
        ),
      ),
    );
  }
}

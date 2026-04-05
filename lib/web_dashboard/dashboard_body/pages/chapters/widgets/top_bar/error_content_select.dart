import 'package:flutter/material.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ErrorContentSelect extends StatelessWidget {
  final String text;
  const ErrorContentSelect({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 250,
      decoration: BoxDecoration(
        color: DashboardTheme.secondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromARGB(255, 154, 2, 2)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(30, 5, 5, 5),
            blurRadius: 5,
            spreadRadius: 5,
            offset: Offset.fromDirection(1, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white54,
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class DataDisplay extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  const DataDisplay({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: 3),
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: DashboardTheme.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(child: Icon(icon, size: 10, color: Colors.white)),
            ),
          ],
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

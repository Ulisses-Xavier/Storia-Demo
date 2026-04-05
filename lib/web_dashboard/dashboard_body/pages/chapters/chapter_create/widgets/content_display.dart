import 'package:flutter/material.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ContentDisplay extends StatelessWidget {
  final ContentModel content;
  const ContentDisplay({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 40,
      decoration: BoxDecoration(
        color: DashboardTheme.secondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Image.network(content.coverMini!, height: 35, width: 10),
            SizedBox(width: 6),
            Text(
              content.title!,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 13, // Consistente com o estilo principal
              ),
            ),
          ],
        ),
      ),
    );
  }
}

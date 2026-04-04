import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ImagesPreview extends StatelessWidget {
  final List<Uint8List> images;
  const ImagesPreview({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: DashboardTheme.secondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 42, 42, 42)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(30, 5, 5, 5),
            blurRadius: 5,
            spreadRadius: 5,
          ),
        ],
      ),
      child:
          images.isEmpty
              ? Center(
                child: Icon(
                  LucideIcons.imageOff,
                  color: Colors.white,
                  size: 25,
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(6),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Image.memory(
                              images[index],
                              fit: BoxFit.fitWidth,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

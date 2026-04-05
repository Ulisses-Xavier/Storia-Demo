import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ChaptersSearchBar extends StatefulWidget {
  final ValueChanged<String> setSearching;
  final ValueChanged<bool> offSearching;
  final bool searching;
  const ChaptersSearchBar({
    super.key,
    required this.setSearching,
    required this.offSearching,
    required this.searching,
  });

  @override
  State<ChaptersSearchBar> createState() => _ChaptersSearchBarState();
}

class _ChaptersSearchBarState extends State<ChaptersSearchBar> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MyTextField(
      height: 45,
      width: 350,
      controller: controller,
      backgroundColor: DashboardTheme.secondary,
      borderRadius: 10,
      border: Border.all(color: const Color.fromARGB(255, 42, 42, 42)),
      tipText: 'Pesquisar...',
      textColor: Colors.white,
      maxLines: 1,
      fontSize: 13,
      distanceBetweenButtons: 3,
      eraseButton:
          widget.searching
              ? MyButton(
                height: 30,
                width: 30,
                isSelected: false,
                color: const Color.fromARGB(50, 42, 42, 42),
                borderRadius: 10,
                alignment: MainAxisAlignment.center,
                icon: LucideIcons.x,
                iconColor: Colors.white,
                iconSize: 12,
                spaceBetween: 0,
                onHover: const Color.fromARGB(255, 55, 55, 55),
                splashColor: const Color.fromARGB(22, 255, 255, 255),
                onTap: () {
                  widget.offSearching(true);
                  controller.clear();
                },
              )
              : null,
      rightButton: MyButton(
        height: 30,
        width: 30,
        isSelected: false,
        color: const Color.fromARGB(50, 42, 42, 42),
        borderRadius: 10,
        alignment: MainAxisAlignment.center,
        icon: LucideIcons.search100,
        iconColor: Colors.white,
        iconSize: 12,
        spaceBetween: 0,
        onHover: const Color.fromARGB(255, 55, 55, 55),
        splashColor: const Color.fromARGB(22, 255, 255, 255),
        onTap: () {
          widget.setSearching(controller.text.trim());
        },
      ),
    );
  }
}

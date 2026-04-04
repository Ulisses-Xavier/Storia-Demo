import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class EditingButton extends StatelessWidget {
  final ValueChanged<bool> editingToggle;
  final bool editing;
  final bool isPublished;
  final ValueChanged resetLastChapterManipulated;
  const EditingButton({
    super.key,
    required this.editing,
    required this.editingToggle,
    required this.resetLastChapterManipulated,
    required this.isPublished,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      isSelected: editing,
      height: 45,
      width: 45,
      selectedColor: DashboardTheme.blue,
      color: DashboardTheme.secondary,
      borderRadius: 10,
      border:
          !editing
              ? Border.all(color: const Color.fromARGB(255, 42, 42, 42))
              : null,
      icon: PhosphorIcons.listDashes(),
      iconColor: Colors.white,
      spaceBetween: 0,
      iconSize: 17,
      alignment: MainAxisAlignment.center,
      onTap: () {
        if (!editing && isPublished) {
          editingToggle(true);
        } else {
          editingToggle(false);
        }
        resetLastChapterManipulated('');
      },
    );
  }
}

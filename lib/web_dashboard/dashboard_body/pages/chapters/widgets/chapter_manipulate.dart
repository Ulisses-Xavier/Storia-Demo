import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ChapterManipulate extends StatefulWidget {
  final bool manipulateAll;
  final ValueChanged<int>? upOrder;
  final ValueChanged<int>? downOrder;
  final int index;
  final Map<String, dynamic> chapter;
  final bool? isHighlighted;
  const ChapterManipulate({
    super.key,
    required this.chapter,
    this.upOrder,
    this.downOrder,
    this.isHighlighted,
    required this.index,
    required this.manipulateAll,
  });

  @override
  State<ChapterManipulate> createState() => _ChapterManipulateState();
}

class _ChapterManipulateState extends State<ChapterManipulate> {
  @override
  Widget build(BuildContext context) {
    final bool isMain = widget.chapter['isMain'] == true;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Ink(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(50, 42, 42, 42),
            border:
                (isMain ||
                        (widget.isHighlighted != null &&
                            widget.isHighlighted == true))
                    ? Border.all(color: DashboardTheme.blue)
                    : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '#${widget.chapter['order'].toString()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.chapter['title'] ?? 'Sem título',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 10),
                    //
                    //
                    //
                    //
                    //Status
                    if (widget.manipulateAll == false && !isMain)
                      Container(
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                          color: DashboardTheme.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            widget.chapter['status'][0].toUpperCase() +
                                widget.chapter['status'].substring(1),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                //
                //
                //
                //Set Order
                if (widget.manipulateAll == true || isMain)
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      children: [
                        MyButton(
                          isSelected: false,
                          height: 25,
                          width: 50,
                          borderRadius: 5,
                          icon: LucideIcons.chevronUp,
                          iconColor: Colors.white,
                          iconSize: 13,
                          alignment: MainAxisAlignment.center,
                          spaceBetween: 0,
                          color: DashboardTheme.blue,
                          onHover: DashboardTheme.blue,
                          onTap: () => widget.upOrder!(widget.index),
                        ),
                        SizedBox(width: 3),
                        MyButton(
                          isSelected: false,
                          height: 25,
                          width: 50,
                          borderRadius: 5,
                          icon: LucideIcons.chevronDown,
                          iconColor: Colors.white,
                          iconSize: 13,
                          alignment: MainAxisAlignment.center,
                          spaceBetween: 0,
                          color: DashboardTheme.blue,
                          onHover: DashboardTheme.blue,
                          onTap: () => widget.downOrder!(widget.index),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

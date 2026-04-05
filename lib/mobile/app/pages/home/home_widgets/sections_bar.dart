import 'package:flutter/material.dart';
import 'package:storia/mobile/color_theme.dart';

class SectionsBar extends StatefulWidget {
  final Map<String, dynamic> section;
  final List<Map<String, dynamic>> data;
  final PageController controller;
  final PageController homeController;
  final ValueChanged<Map<String, dynamic>> setSection;
  const SectionsBar({
    super.key,
    required this.section,
    required this.setSection,
    required this.controller,
    required this.data,
    required this.homeController,
  });

  @override
  State<SectionsBar> createState() => _SectionsBarState();
}

class _SectionsBarState extends State<SectionsBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: PageView.builder(
        itemCount: widget.data.length,
        controller: widget.controller,
        scrollDirection: Axis.horizontal,
        padEnds: false,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final tag = widget.data[index]['tag'];
          final isSelected = widget.section['tag'].id == tag.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(17),
                splashColor: ColorTheme.grey,
                onTap: () {
                  widget.setSection({'index': index, 'tag': tag});
                  widget.homeController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: 40,
                  curve: Curves.easeOutCubic,
                  width: 120,
                  decoration: BoxDecoration(
                    color: !isSelected ? null : ColorTheme.blue,
                    borderRadius: BorderRadius.circular(17),
                    border:
                        isSelected
                            ? null
                            : Border.all(
                              color: ColorTheme.grey.withAlpha(200),
                              width: 0.7,
                            ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      child: Text(
                        tag.title,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : ColorTheme.grey.withAlpha(200),
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
